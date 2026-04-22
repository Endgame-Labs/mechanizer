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

## Runtime Contract
- One due run every 15 minutes.
- On-time run starts within `grace_period_seconds` (120s) of expected tick.
- Overlap policy: `forbid` to prevent concurrent write attempts.
- Run success requires:
- full pipeline completion
- approval decisions finalized
- output events emitted
- terminal heartbeat emitted

## Approval Contract
- Salesforce writes and outbound messaging are approval-gated.
- Prompt-unavailable approvals resolve by deny fallback.
- Approval timeout defaults to 30 minutes and is treated as denied.
- Denied actions are non-retryable for current run.

## Retry Contract
- Scheduler/bootstrap transient failures: 2 retries (10s, 30s).
- Fetch/transform transient failures: 3 retries (5s, 20s, 60s).
- Approval transport transient failures: 2 retries (10s, 30s).
- Non-retryable: policy deny, approval timeout, schema/contract validation failure.

## Safe-Mode Contract
- Trigger safe mode on stale transition or dependency degradation.
- Safe mode behavior:
- perform read-only hygiene scoring and diagnostics
- block all write side effects
- emit `deal_hygiene.machine.safe_mode`
- Exit safe mode only after one complete successful run.

## Stale and Alert Rules
- Mark stale when no successful heartbeat for `stale_after_seconds` (1800s).
- On stale transition:
- emit `deal_hygiene.machine.stale`
- alert all `alert_channels`
- enforce safe mode
- Alert immediately on 2 consecutive missed due runs.
