# Claude Routines Adapter (sales-coaching-machine)

Routine-centric implementation for Claude-driven coaching generation, aligned to current Claude routine behavior in April 2026.

## Runtime Model (Current Claude Behavior)
- Runs as a Claude Code cloud routine session.
- Supported triggers: schedule, API, and GitHub events.
- Routine runs are autonomous with no in-run permission prompts.
- Routines are research preview features; behavior and limits may change.

## Implementation Steps
1. Use [`routine.md`](./routine.md) as the execution definition.
2. Bind tool endpoints:
- `get_endgame_context`
- `extract_call_insights`
- `check_directive_alignment`
- `approval_loop`
- `create_salesforce_task`
- `emit_event`
3. Enforce precheck: input must match `gtm_event_v1`.
4. Run quality and approval gates from `routine.md` before any CRM write.
5. Keep fallback branches enabled for missing context or alignment-service degradation.

## Required Guarantees
- Contract keys are never renamed or removed.
- Trace lineage (`trace_id`) is copied to every tool call.
- Alignment failures cannot auto-create CRM tasks.
- Claude routine autonomy does not bypass manager approval policy.
