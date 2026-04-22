# Agentic Runbook (nrr-machine)

## Input and Preconditions
- Input contract: `gtm_event_v1`
- Supported `event_type` values: `account.health_changed`, `usage.declined`, `renewal.window_opened`
- Required fields: `event_id`, `event_type`, `source`, `occurred_at`, `subject.id`
- Hard gate: skip execution if account segment is not `low_touch` or `no_touch`

## Runtime Assumptions
- Provider-neutral runtime (OpenAI Agents SDK, LangGraph, or CrewAI style orchestration).
- Checkpoint state at every stage boundary; resume from checkpoint on retries and HITL return.
- MCP pattern preferred for context providers and tool routers (`tools/call`, `resources/read`, optional `prompts/get`).

## Stage 1: Normalize and Validate
- Validate schema and semantic requirements.
- Generate `run_id` and initialize trace lineage.
- Check dedupe store by `event_id`; exit if already completed.

## Stage 2: Context Enrichment
Tool requirements:
- `endgame_mcp` + `endgame-cli`: directive context, conversation history, account timeline
- `salesforce_headless_360`: renewal and opportunity context
- telemetry + billing readers: usage trend and commercial indicators

Outputs:
- canonical feature set: `risk_signals`, `expansion_signals`, `renewal_signals`
- source freshness timestamps for each provider

## Stage 3: Scoring and Play Selection
Deterministic scoring baseline:
- `risk_score = 0.5*health_decline + 0.3*renewal_risk + 0.2*engagement_drop`
- `expansion_score = 0.4*seat_growth + 0.3*feature_adoption + 0.3*intent_signals`
- `final_score = max(risk_score, expansion_score)`

Play selection:
- `critical_retention` if `risk_score >= 78`
- `expansion_push` if `expansion_score >= 72` and `risk_score < 60`
- `monitor_and_nudge` otherwise

## Stage 4: Draft Plan and Messaging
- Draft outbound communication and SFDC update plan.
- Attach reason codes and supporting evidence links.
- Bind all recommendations to directive IDs.

## Stage 5: Guardrails and Policy Checks
Policy checks must pass before approval request:
- Contract integrity: no missing required output keys.
- Directive alignment: no blocked language (discounting, unsupported claims).
- Action scope: no outbound/SFDC write outside approved play template.
- Risk policy: strategic/enterprise segment must be blocked (manual handoff only).
- Tool guardrails: reject unsafe or out-of-scope tool arguments before execution.
- Output guardrails: reject incomplete action plans that cannot be explained with evidence.

Failure behavior:
- Any failed policy emits `nrr.play.blocked`.
- Include `policy_code`, `policy_detail`, and suggested remediation.

## Stage 6: Approval Loop (Mandatory for Side Effects)
- Send approval request with:
- `event_id`, `run_id`, `account_id`, score snapshot, action plan, policy check results
- Wait up to 30 minutes.
- Retry approval API up to 2 times on transport errors.
- HITL decision envelope supports `approve`, `reject`, and constrained `edit` (template-safe fields only).
- Outcomes:
- `approved`: proceed to Stage 7
- `rejected`: emit blocked event and stop
- `timeout`: emit blocked event (`approval_timeout`) and stop

## Stage 7: Execute Side Effects
- Outbound message send (email/sequencer) only if approved.
- Salesforce writes only if approved.
- Enforce idempotent write keys: `event_id + action_type + target_id`.
- Retry once for transient 5xx errors.

## Stage 8: Emit Output and Audit
- Emit `gtm_event_v1` output: `nrr.play.executed`, `nrr.play.blocked`, or `nrr.play.failed`.
- Persist audit record:
- score inputs/outputs
- selected play
- policy decisions
- approval decision metadata
- side-effect result IDs

## Observability SLOs
- Realtime path P95 end-to-end <= 240s
- Approval latency P95 <= 20m
- Failed side effects < 2% daily
- Missing trace lineage = 0 tolerated

## Trace Requirements
- Minimum span set: `ingest_validate`, `context_fetch`, `score`, `draft`, `policy_gate`, `approval_wait`, `execute`, `emit`.
- Every span includes `machine_id`, `event_id`, `run_id`, `trace_id`, and `policy_result`.
- Capture retry attempts and cost/latency metadata per tool call.

## Retry and Incident Handling
- Retry budget: max 3 stage retries per run (excluding approval wait polling).
- After retry budget exhausted, mark `failed_terminal` and alert on-call.
- If 3 consecutive `failed_terminal` runs in 15 minutes, pause outbound actions and keep scoring-only mode until cleared.

## Evals
- Maintain fixed benchmark set for play-selection consistency across runtime/provider changes.
- Run trace-based grading on:
  - Play correctness and justification quality.
  - Policy/guardrail precision (blocked vs allowed decisions).
  - HITL outcome handling correctness.
- Require no safety regressions before rollout of prompt, model, or orchestration changes.
