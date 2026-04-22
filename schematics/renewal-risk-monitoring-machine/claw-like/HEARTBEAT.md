# HEARTBEAT

machine_id: renewal-risk-monitoring-machine
heartbeat_version: v1
schedule_cron: "0 7 * * *"
timezone: "America/Los_Angeles"
grace_period_seconds: 600
stale_after_seconds: 93600
owner: "customer-success-ops"
alert_channels:
  - "slack:#renewal-risk-alerts"
  - "email:csops-oncall@example.com"

## Cron Semantics
- Format: `minute hour day_of_month month day_of_week`
- `0 7 * * *` runs once daily at 07:00 in `America/Los_Angeles`.
