# HEARTBEAT

machine_id: nrr-machine
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
- On-time start window: scheduled tick plus `grace_period_seconds` (120s).
- Overlap policy: `forbid` (skip overlapping start and count as missed tick).
- Success requires:
- pipeline completion
- approval outcomes finalized
- output events emitted
- final heartbeat emitted

## Approval Contract
- Outbound email and Salesforce writes require explicit approval completion.
- Prompt-unavailable approval path resolves with deny behavior.
- Approval timeout defaults to 30 minutes and is treated as denied.
- Denied actions must not be retried unless a new run creates a new intent.

## Retry Contract
- Scheduler/bootstrap transient failures: 2 retries (10s, 30s).
- Account-stage transient failures: 3 retries (5s, 20s, 60s).
- Approval transport transient failures: 2 retries (10s, 30s).
- Non-retryable: schema validation failure, policy deny, approval timeout, incompatible input contract.

## Safe-Mode Contract
- Trigger safe mode when stale or when approval/side-effect dependencies are unhealthy.
- Safe mode behavior:
- continue scoring and diagnostics
- block all outbound/SFDC side effects
- emit `nrr.machine.safe_mode` with reason
- Exit safe mode only after one full successful run.

## Stale and Alert Contract
- Stale threshold: no successful heartbeat for `stale_after_seconds` (1800s).
- On stale transition:
- emit `nrr.machine.stale`
- alert each channel in `alert_channels`
- enforce safe mode until recovery
- Page on-call after 2 consecutive missed due runs.
- Alert payload must include `machine_id`, `run_id`, `last_success_at`, `failure_stage`, `safe_mode`.
