# HEARTBEAT

machine_id: pipeline-review-intelligence-machine
heartbeat_version: v1
schedule_cron: "0 7 * * 1"
timezone: "America/Los_Angeles"
grace_period_seconds: 300
stale_after_seconds: 1209600
owner: "revenue-ops"
alert_channels:
  - "slack:#revops-pipeline-alerts"
  - "email:revops-oncall@example.com"

## Cron Semantics
- Format: `minute hour day_of_month month day_of_week`
- `0 7 * * 1` runs every Monday at 07:00 in the declared timezone.

## Runtime Contract
- One due run per week.
- Overlap policy: `forbid`.
- Success requires full summary generation, routing, approval handling, and terminal event emission.

## Approval Contract
- Outbound manager summary delivery and high-impact mutations are approval-gated.
- Approval timeout defaults to 30 minutes and resolves as denied.

## Retry Contract
- Scheduler/bootstrap transient failures: 2 retries (30s, 120s).
- Fetch/transform transient failures: 3 retries (10s, 60s, 180s).
- Approval transport transient failures: 2 retries (30s, 120s).

## Stale and Alert Rules
- Mark stale when no successful heartbeat for `stale_after_seconds` (14 days).
- On stale transition:
- emit `pipeline_review_intelligence.machine.stale`
- alert all configured channels
- enforce safe mode until a healthy run completes
