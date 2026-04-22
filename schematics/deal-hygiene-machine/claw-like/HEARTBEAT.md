# HEARTBEAT

machine_id: deal-hygiene-machine
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

## Health Rules
- Emit heartbeat only after a successful full run.
- Mark stale if no success within `stale_after_seconds`.
- Alert immediately on 2 consecutive missed expected runs.
