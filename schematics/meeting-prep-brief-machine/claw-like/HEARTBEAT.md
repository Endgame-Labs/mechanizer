# HEARTBEAT

machine_id: meeting-prep-brief-machine
heartbeat_version: v1
schedule_cron: "*/15 * * * *"
timezone: "America/Los_Angeles"
grace_period_seconds: 120
stale_after_seconds: 1800
owner: "revenue-ops"
alert_channels:
  - "slack:#revops-alerts"
  - "email:revops-oncall@example.com"

## Cron Semantics
- Format: `minute hour day_of_month month day_of_week`
- `*/15 * * * *` runs every 15 minutes.
- Interpret in `timezone` above.

## Run Cycle Semantics
- One run expected every 15 minutes.
- Run is on-time if it starts within `grace_period_seconds`.
- Run is successful only after delivery outcomes are emitted.

## Stale Rules
- Mark stale when last successful heartbeat exceeds `stale_after_seconds`.
- On stale transition:
- emit `meeting.prep_brief.machine.stale`
- alert all `alert_channels`
- suppress Slack/email side effects (draft-only mode)
