# HEARTBEAT

machine_id: stage-change-deal-review-machine
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

## Run Contract
- One due run every 15 minutes.
- Start within `grace_period_seconds` for on-time status.
- Success requires terminal output event emission.

## Stale Rules
- Mark stale when no successful heartbeat for `stale_after_seconds`.
- On stale transition:
- emit `deal.stage_review.machine.stale`
- alert all `alert_channels`
- enforce read-only safe mode until recovery
