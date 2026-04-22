# Claude Routines Adapter (deal-hygiene-machine)

## Purpose
Routine-oriented implementation where each phase maps to a specific smart cog and deterministic contract check, updated to current Claude routines constraints.

## Runtime Model (Current Claude Behavior)
- Runs as a Claude Code cloud routine session.
- Trigger options: schedule, API, GitHub event.
- Routine runs are autonomous and do not surface permission prompts during execution.
- Routines are in research preview with mutable limits and API surface.

## Routine Asset
- `routine.md`: executable routine spec with phase order, tool calls, and output schema references.

## Guardrails
- Routine must validate input against `gtm_event_v1` before reasoning.
- Prompted reasoning may propose actions, but only the `approval_loop` phase can authorize mutation.
- Output emission must always conform to `gtm_event_v1` required keys.
- Treat Claude runtime autonomy as transport, not policy authorization.

## Failure Policy
- Validation failures are terminal (`deal.hygiene.failed_validation`).
- Provider/tool failures retry up to machine policy limits, then emit failure event and dead-letter metadata.
