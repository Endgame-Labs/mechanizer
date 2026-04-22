# HEARTBEAT

machine_id: sales-coaching-machine
heartbeat_version: v1
schedule_cron: "*/15 * * * *"
timezone: "America/Los_Angeles"
grace_period_seconds: 120
stale_after_seconds: 1800
owner: "revenue-ops"
alert_channels:
  - "slack:#revops-alerts"
  - "email:revops-oncall@example.com"

## Scheduled Jobs
- `*/15 * * * *`: process recent `call.completed` events and run coaching pipeline.
- `0 17 * * 1-5`: send manager digest for pending `needs_review` coaching items.

## Runtime Contract
- Primary due cadence is every 15 minutes from `schedule_cron`.
- Start within `grace_period_seconds` (120s) of due tick to be on-time.
- Overlap policy is `forbid`; overlapping tick is counted as missed.
- Success requires:
- poll/checkpoint success
- event pipeline completion for all selected events
- heartbeat emission at run end

## Approval Contract
- Task creation with external side effects must pass approval gate.
- If approval path is unavailable, deny by fallback and log `approval_unavailable`.
- Approval timeout is 30 minutes default and treated as denied.

## Retry Contract
- Poll/enrichment transient failures: 3 retries (10s, 30s, 90s).
- Alignment service transient failures: 2 retries (15s, 45s).
- Approval transport transient failures: 2 retries (10s, 30s).
- Non-retryable: invalid event schema, policy deny, approval timeout.

## Safe-Mode Contract
- Enter safe mode when stale, alignment service fails in 2 consecutive runs, or approval transport is degraded.
- Safe mode actions:
- continue event polling and scoring
- convert auto-created coaching tasks to `needs_review` queue entries only
- keep daily digest enabled with safe-mode marker
- Exit safe mode after one full successful run with healthy dependencies.

## Stale and Alert Rules
- Mark stale when no successful heartbeat for `stale_after_seconds` (1800s).
- On stale transition:
- emit `sales_coaching.machine.stale`
- alert all `alert_channels`
- enforce safe mode
- Page on-call after 2 consecutive missed due runs.
- Warn when per-run alignment failure rate exceeds 30%.
