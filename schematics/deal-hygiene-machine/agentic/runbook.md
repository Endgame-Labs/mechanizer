# Agentic Runbook (deal-hygiene-machine)

## Contracts
- Input schema: `gtm_event_v1`
- Output schema: `gtm_event_v1`
- Cog order (from `machine.yaml`):
  1. `enrich_account_health@v1.0.0`
  2. `deal_score_reasoner@v1.0.0`
  3. `directive_alignment@v1.0.0`
  4. `route_exec_alert@v1.0.0`
  5. `approval_loop@v1.0.0`

## Runtime Assumptions
- Orchestrator is provider-neutral (OpenAI Agents SDK, LangGraph, or CrewAI style runtime are all valid).
- State is checkpointed between phases to support pause/resume and HITL waits.
- MCP pattern is preferred for context servers:
  - `tools/call` for fetch and action endpoints
  - `resources/read` for static context (playbooks, directives)
  - optional `prompts/get` for reusable prompt templates

## Phase 1: Intake, Validation, and Dedupe
- Tool: `validate_gtm_event`
- Required keys: `schema_version`, `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`, `trace.trace_id`, `subject.entity_type`, `subject.entity_id`.
- On failure: emit `deal.hygiene.failed_validation` with `attributes.validation_errors[]`; stop execution.
- Dedupe on immutable `event_id`; if terminal output already exists, emit idempotent skip metadata and stop.

## Phase 2: Context Assembly
- Tools: `endgame_mcp_context_fetch`, `crm_snapshot_fetch`
- Output additions:
  - `attributes.enrichment.context_sources[]`
  - `attributes.enrichment.account_health_inputs`
- Timeout budget: 30s total.

## Phase 3: Cog Execution
1. `enrich_account_health`
  - Adds normalized health metrics under `metrics.*` and `attributes.enrichment`.
2. `deal_score_reasoner`
   - Writes `attributes.hygiene_score`, `attributes.score_band`, `attributes.recommended_play`.
3. `directive_alignment`
   - Writes `attributes.directive_alignment` including `allowed`, `required_approver_role`, `violations[]`.
4. `route_exec_alert`
  - Writes `attributes.routing` and emits non-mutating alerts/tasks as needed.

## Phase 4: Guardrails and Policy Gates
- Guardrail classes:
  - Input guardrail: contract + schema + subject scope.
  - Tool guardrail: reject unsafe tool arguments and out-of-policy targets.
  - Output guardrail: ensure required terminal attributes can be populated before emit.
- Policy result is captured in `attributes.policy_checks[]` with deterministic reason codes.

## Phase 5: Approval Gate (Mandatory for Mutations)
- Tool: `approval_loop`
- Input: proposed mutation set (`attributes.proposed_mutations[]`) and directive alignment result.
- Outcomes:
  - `approved`: continue to writeback phase.
  - `rejected|needs_info|expired`: emit `deal.hygiene.deferred`; skip writeback.
- HITL response contract supports `approve`, `reject`, and optional constrained `edit` on mutation payloads.

## Phase 6: Writeback and Emit
- Tool: `sfdc_writeback` (approved only)
- Post-action tool: `emit_gtm_event`
- Success event type: `deal.hygiene.remediated`
- Required terminal attributes:
  - `approval_status`
  - `hygiene_score`
  - `recommended_play`
  - `writeback_actions[]`

## Idempotency and Retry
- Idempotency key: `event_id`.
- Duplicate handling: if terminal event already exists for same `event_id`, stop and record idempotent skip.
- Retry policy: max 3 retries, exponential backoff for transient provider/action errors.
- For async/background execution modes, resume retries from latest checkpoint, never from raw input replay.

## Observability
- Preserve `trace.trace_id` from input.
- Set `trace.run_id` per execution attempt.
- Log per-phase duration, retry count, guardrail outcomes, approval latency, and terminal state.
- Recommended span taxonomy: `validation`, `context_fetch`, `cog_execution`, `policy_gate`, `approval_wait`, `writeback`, `emit`.

## Evals
- Maintain regression dataset from sampled traces across terminal states.
- Grade:
  - Directive alignment accuracy.
  - Correctness of `hygiene_score`/`recommended_play`.
  - Mutation safety (no write without approval).
- Block production promotion when eval score drops below agreed threshold or when safety regressions are detected.
