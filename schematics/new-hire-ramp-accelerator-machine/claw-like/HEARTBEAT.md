# HEARTBEAT

machine_id: new-hire-ramp-accelerator-machine
heartbeat_version: v1
schedule_cron: "*/20 * * * *"
timezone: "America/Los_Angeles"
grace_period_seconds: 180
stale_after_seconds: 2700
owner: "revenue-enablement"
alert_channels:
  - "slack:#enablement-alerts"
  - "email:enablement-oncall@example.com"

## Cron Semantics
- Format: `minute hour day_of_month month day_of_week`
- `*/20 * * * *` runs every 20 minutes.
- Interpret in `timezone` above.

## Health Rules
- Emit heartbeat only after successful run completion.
- Mark stale if no success within `stale_after_seconds`.
- Alert on 2 consecutive missed expected runs.
