# Zapier Adapter (nrr-machine)

This adapter provides a low-code implementation of `nrr-machine` using Zapier trigger/filter/path steps with an explicit approval gate before outbound and Salesforce actions.

## Artifact
- Sample template: `zap.template.json`
- Load as a base template, then bind app credentials and webhook URLs.

## Trigger Paths
1. Realtime inbound webhook:
- Trigger app: `Webhooks by Zapier - Catch Hook`
- Accepts canonical `gtm_event_v1` events.

2. Scheduled sweep:
- Trigger app: `Schedule by Zapier`
- Runs every 6 hours to score low-touch/no-touch cohorts.

## Scoring and Routing
- Filter to supported trigger events:
- `account.health_changed`
- `usage.declined`
- `renewal.window_opened`
- Segment policy: continue only when `segment in [low_touch, no_touch]`.
- Score formula (sample):
- `score = 0.45*health_risk + 0.35*renewal_risk + 0.20*expansion_signal`
- Path routing:
- `critical` if score >= 78
- `expansion` if score >= 72 and renewal risk < 60
- `monitor` otherwise

## Approval Loop (Mandatory)
- Before `Gmail/Outreach` send or `Salesforce` update, call approval endpoint.
- Required approval metadata:
- `event_id`, `account_id`, `score`, `play_type`, planned actions, reason codes
- Rejected or timed-out requests branch to "Blocked" path and emit blocked event.

## Zapier Runtime Capabilities and Limits (verified 2026-04-22)
- Paths:
  - Up to 10 path branches per path group and up to 3 nested Paths steps per Zap.
  - Paths execute sequentially left-to-right; slow earlier branches delay later branches.
  - Paths must be final in Zap flow and do not support shared steps after branching.
- Filters:
  - Failed filter stops the run before subsequent actions.
  - Filters and Paths do not count toward task usage.
  - Line-item filtering behavior changes when negative conditions are used.
- Code by Zapier:
  - JavaScript and Python supported for small transforms.
  - JavaScript runtime is Node.js 22.
  - I/O limit is 6 MB; runtime and throughput limits vary by plan.
- Webhooks:
  - Catch Raw Hook max payload 2 MB.
  - Webhook trigger/action payload practical caps: 10 MB trigger, 5 MB action.
  - Webhooks by Zapier rate limits: 20,000 requests/5 min per user; legacy route cap 1,000/5 min per Zap.
- Retries/replay:
  - Zapier autoreplay can replay failed errored steps up to 5 attempts.
  - Filter and Paths are not replayed.
  - Replays require Zap enabled and available tasks.
- Template mechanics:
  - Shared Zap templates copy step structure only, not field values.
  - Guided templates can include preconfigured values with locked/editable controls and setup instructions.
- Import/export:
  - Team/Enterprise only; JSON-only export/import format.
  - Non-owner exports are limited to owned Zaps.

## Observability Guidance
- Add storage/log step containing:
- `run_id`, `event_id`, `trace_id`, `trigger_path`, `segment`, `score_band`
- `approval_status`, `approval_latency_ms`, `action_execution_ms`
- `error_code`, `retry_count`
- Maintain a daily report of:
- conversion to approved actions
- blocked reasons
- failed side effects by app

## Reliability Notes
- Use dedupe key `event_id` in storage before side effects.
- Configure auto-replay for transient failures.
- Keep retries idempotent for Salesforce writes.
