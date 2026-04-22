# HEARTBEAT

machine_id: tier-3-account-coverage-machine
heartbeat_version: v1
schedule_cron: "*/20 * * * *"
timezone: "America/Los_Angeles"
grace_period_seconds: 120
stale_after_seconds: 2400
owner: "customer-success-ops"
alert_channels:
  - "slack:#csops-alerts"
  - "email:csops-oncall@example.com"

## Cron Semantics
- Format: `minute hour day_of_month month day_of_week`
- `*/20 * * * *` runs every 20 minutes.
- Interpret in `timezone` above.

## Run Cycle Semantics
- One run is expected every 20 minutes.
- A run is on-time when it starts within `grace_period_seconds`.
- A run is successful only after terminal event emission and heartbeat write.

## Retry Semantics
- Scheduler start failure: retry 2 times.
- Account-level processing failure: retry up to 3 times with exponential backoff.
- Approval transport failure: retry 2 times; approval timeout is non-retryable.

## Stale Rules
- Mark stale when last successful heartbeat exceeds `stale_after_seconds`.
- On stale transition:
- emit `tier3.coverage.stale`
- alert all `alert_channels`
- switch to score-only mode (suppress side effects)
- Clear stale only after one full successful run.
