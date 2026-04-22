# HEARTBEAT

machine_id: ai-sdr-outbound-machine
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
- Interpret schedule in declared `timezone`.

## Runtime Contract
- One due run every 15 minutes.
- Success requires:
- successful ingest and normalization
- alignment + approval decision resolution
- event emission and heartbeat emission

## Stale and Alert Rules
- Mark stale when no successful run in `stale_after_seconds`.
- On stale transition, emit `sdr.machine.stale` and notify all `alert_channels`.
- Page on-call after 2 consecutive missed due runs.
