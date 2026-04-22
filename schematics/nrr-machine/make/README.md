# Make Adapter (nrr-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style artifact for Make scenario import.
- Keep blueprint JSON under 2 MB and reconnect all app connections after import.

## Trigger Paths
1. Webhook path (instant):
- Ingest canonical `gtm_event_v1` from source systems.

2. Scheduled rescoring path:
- Use scenario schedule for periodic rescoring windows (for example every 6 hours).
- For high-volume periods, combine schedule interval and max cycles/results to avoid queue growth.

## Module Flow
1. Parse and validate required canonical fields.
2. Enrich account context.
3. Segment gate (`low_touch`, `no_touch`).
4. Compute score and route play type.
5. Build plan and request approval.
6. Approved route performs email/SFDC side effects.
7. Blocked route emits blocked event only.
8. Persist observability row in Data Store.

## Scoring Policy
- `critical`: score >= 78
- `expansion`: score >= 72 and `health_risk < 60`
- `monitor`: default

## Scheduling, Webhooks, and Queues
- Instant webhook scenarios process in parallel by default.
- Enable sequential processing when strict per-account ordering is required.
- If runs are capped by scenario rate limit, Make queues excess webhook-triggered runs.
- Scheduled webhook mode buffers requests in webhook queue and drains each run per max results/cycles.
- Expect `429` when exceeding documented webhook ingress/rate controls.

## Retries and Failure Model
- Keep `Store incomplete executions` enabled for operational recovery.
- Make automatic retry/backoff applies to `RateLimitError`, `ConnectionError`, and `ModuleTimeoutError`.
- Backoff delays increase across attempts (1m, 10m, 10m, 30m, 30m, 30m, 3h, 3h).
- Automatic retries are processed with a per-scenario parallel retry cap (3 retries at once).
- Use error-handler dead-letter route for semantic failures that retries cannot heal.

## History, Replay, and Versioning Constraints
- Version History restores manually saved versions (documented up to 60 days).
- There is no true undo; save before major router/filter edits.
- Run Replay consumes credits and replays trigger data through current scenario logic.
- Replay availability follows run-history retention by plan.

## Approval Contract
- Approval loop is mandatory and precedes all outbound communication or CRM mutation.
- Timeout/reject/needs-info outcomes remain non-mutating (`nrr.play.blocked` path).
