# Agentic Adapter (nrr-machine)

Provider-agnostic manager-worker execution of `nrr-machine`, preserving contract behavior while allowing tool-based enrichment and action orchestration.

## Purpose
- Keep deterministic contract checks and policy guardrails.
- Use agentic reasoning only for explanation/message composition, not contract mutation.

## Runtime Pattern
- Manager-worker graph with resumable checkpoints (supports approval pauses and retries).
- MCP-first context integration for tools/resources/prompts where available.
- Supports synchronous execution and background continuation for long-running approval windows.

## Required Tools
- `contract_validator` for `gtm_event_v1`
- `endgame_mcp` and `endgame-cli` for account context and directives
- `salesforce_headless_360` (read/write)
- `telemetry_reader` and `billing_reader`
- `approval_loop` endpoint/tool
- `event_emitter` for output contract events

## Execution Shape
1. Manager validates input and allocates workers.
2. Worker A: context enrichment + feature extraction.
3. Worker B: scoring and play recommendation.
4. Worker C: message/action draft.
5. Manager runs policy checks and approval loop.
6. Approved actions execute, then output event emits.

## Deterministic Guardrails
- Never alter required contract keys.
- Enforce `segment in [low_touch, no_touch]` before scoring.
- Apply tool-risk policy tiers and block high-risk side effects pending HITL.
- Enforce approval before outbound/SFDC write actions.
- Enforce idempotency by `event_id` and side-effect hash.

## Observability
- Track per-worker latency and token/tool budgets.
- Persist `trace_id`, `run_id`, selected play, score inputs, policy outcomes.
- Emit explicit blocked/failure events with reason codes.

## Tracing and Evals
- Trace spans should include guardrails, tool invocations, handoffs, and approval waits.
- Keep a replayable eval set from production traces (sanitized) for score stability and policy-regression checks.
- Include trace grading/QA of play selection and policy adherence prior to runtime changes.

See `runbook.md` for full stage and policy details.
