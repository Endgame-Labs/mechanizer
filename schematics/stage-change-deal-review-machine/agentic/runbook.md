# Agentic Runbook (stage-change-deal-review-machine)

## Runtime Contract
- Orchestration shape: **planner -> executor -> evaluator** with checkpoint persistence.
- Input schema: `gtm_event_v1`
- Output schema: `gtm_event_v1`
- Idempotency key: `event_id` (side effects use `event_id + action_type + target_id`).

## Canonical Ingest Contract (`gtm_event_v1`)
Required keys at stage entry:
- `schema_version`, `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`
- `trace.trace_id`
- `subject.entity_type`, `subject.entity_id`

## Stage 1: Planner (Validate, Dedupe, Plan)
1. Validate contract and semantic preconditions for allowed `event_type` values.
2. Dedupe by `event_id`; if already terminal, return prior outcome metadata.
3. Build execution plan:
   - context fetch tools
   - scoring/enrichment tools
   - proposed side effects
4. Assign `risk_tier` (`low|medium|high`) and approval requirements.

## Stage 2: Executor (Tools + Cogs)
1. Read context through MCP/CLI adapters (CRM, telemetry, conversation history, directives).
2. Execute reusable cogs in declared order.
3. Generate normalized candidate output (`draft_event`) and `proposed_actions[]`.
4. Persist per-tool latency, retries, and evidence references.

### MCP/CLI Tool Contract Rules
- Discover: `tools/list`, `resources/list`, `prompts/list`
- Invoke/read: `tools/call`, `resources/read`, `prompts/get`
- Reject unsafe arguments before execution (domain, scope, tenant, object ownership checks).
- For CLI-executed actions: non-interactive only, bounded timeout, capture stdout/stderr, audit every invocation.

## Stage 3: Evaluator (Guardrails + HITL + Emit)
1. **Input guardrail**: schema + scope + replay constraints.
2. **Tool guardrail**: allowed tool/action set for this machine.
3. **Output guardrail**: required terminal attributes + evidence completeness.
4. **Policy guardrail**: directive alignment and prohibited-language checks.
5. **Approval gate** (when required) before any write/email/send action.
6. Execute approved side effects and emit final `gtm_event_v1` terminal event.

## OpenAI and Claude Execution Notes
- OpenAI-style: use Responses/Agents SDK loop; `tool_choice` and MCP approval configs can enforce stronger control.
- Claude-style: run tool loop until stop reason is terminal; on `tool_use`, return matched `tool_result` blocks in the next user turn.
- For Claude MCP connector mode, remote MCP tool calls are supported directly; prompts/resources require client-side MCP handling.

## HITL Gate for Email/CRM Writes
- Required for stage writeback and outbound findings delivery.
- Decision envelope: approve/reject/edit with constrained field-level edits.
- Reject or timeout triggers findings-only path and non-mutating terminal event.

## Scheduled/Background Semantics
- Event-driven default; scheduled mode supported for periodic sweeps.
- Background execution permitted for long context pulls or approval waits.
- Resume from checkpoint; never replay already-committed side effects.

## Terminal Events
- deal.stage_review.writeback_applied
- deal.stage_review.findings_posted
- deal.stage_review.blocked
- deal.stage_review.failed

## Operational SLOs and Failure Policy
- Retry transient tool failures with exponential backoff (max 3 attempts unless stricter machine policy applies).
- On policy/HITL denial, emit blocked/deferred terminal event with reason codes.
- On exhausted retries, emit failed terminal event and alert owner channel.
