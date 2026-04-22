# HEARTBEAT

machine_id: account-plan-generation-machine
heartbeat_version: v1
schedule_cron: "*/30 * * * *"
timezone: "America/Los_Angeles"
grace_period_seconds: 180
stale_after_seconds: 3600
owner: "revenue-ops"
alert_channels:
  - "slack:#revops-alerts"
  - "email:revops-oncall@example.com"

## Cron Semantics
- Format: `minute hour day_of_month month day_of_week`
- `*/30 * * * *` runs every 30 minutes.
- Interpret in `timezone` above.

## Health Rules
- Emit heartbeat only after successful run completion.
- Mark stale if no success within `stale_after_seconds`.
- Alert on 2 consecutive missed expected runs.
