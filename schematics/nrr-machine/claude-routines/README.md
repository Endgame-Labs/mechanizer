# Claude Routines Adapter (nrr-machine)

Claude Code routine implementation of `nrr-machine`, updated for current Claude routines behavior in April 2026.

## Runtime Model (Current Claude Behavior)
- Runs as a Claude Code cloud session (Anthropic-managed infrastructure).
- Trigger options: schedule, API, and GitHub event.
- Routine runs are autonomous: no in-run permission prompts or approval-mode picker.
- Routines are in research preview; API surface, limits, and token semantics can change.

## Artifacts
- Routine specification: `routine.md`

## Tool and Connector Requirements
- Endgame context: `endgame_mcp`, `endgame-cli`
- CRM context/actions: `salesforce_headless_360`
- Signals: telemetry and billing readers
- Approval gate: `approval_loop`
- Output emission: `event_emitter`

## Trigger Paths
- API-triggered routine for machine events (`account.health_changed`, `usage.declined`, `renewal.window_opened`) from upstream ingestion.
- Optional schedule trigger for low-touch/no-touch cohort rescoring.

## Mandatory Policies
- Keep `gtm_event_v1` keys and semantics intact.
- Segment filter (`low_touch`, `no_touch`) must pass before scoring.
- Explicit `approval_loop` decision required before outbound communication or SFDC write.
- Treat Claude routine autonomy as execution transport only, not business approval.

## Observability Guidance
- Capture stage-level timings and policy outcomes.
- Log `run_id`, `event_id`, `trace_id`, score details, selected play, approval outcome.
- Emit blocked/failed events with machine-readable reason codes.
