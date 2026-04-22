# HEARTBEAT

machine_id: account-health-audit-machine
heartbeat_version: v1
schedule_cron: "0 6 * * 1-5"
timezone: "America/Los_Angeles"
grace_period_seconds: 300
stale_after_seconds: 5400
owner: "customer-success-ops"
alert_channels:
  - "slack:#cs-ops-alerts"
  - "email:csops-oncall@example.com"

## Cron Semantics
- Format: `minute hour day_of_month month day_of_week`
- `0 6 * * 1-5` runs at 06:00 every Monday through Friday.
- Interpret in `timezone` above.

## Health Rules
- Emit heartbeat only after successful audit completion.
- Mark stale if no success within `stale_after_seconds`.
- Alert immediately on 2 consecutive missed runs.
