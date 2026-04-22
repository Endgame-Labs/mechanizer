# Make Adapter (deal-hygiene-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: importable blueprint-style artifact for this machine.
- Keep blueprint files under 2 MB, or Make will not import/save the scenario.

## Runtime Pattern
1. Trigger via `Webhooks > Custom webhook` (`deal-hygiene-machine` path).
2. Normalize inbound payload to canonical `gtm_event_v1`.
3. Enrich and score through shared smart cogs.
4. Run mandatory `approval_loop`.
5. Only approved path executes side effects (`Salesforce` writeback).
6. Emit terminal event (`deal.hygiene.remediated` or `deal.hygiene.deferred`).
7. Upsert idempotency status in Make Data Store.

## Scheduling, Queueing, and Ordering
- Use `Immediately` for low-latency intake.
- Enable scenario-level sequential processing when strict event order is required for the same subject/deal.
- If intake rate spikes, cap `maximum runs per minute` so Make queues excess runs instead of bursting downstream APIs.
- If webhook traffic is intentionally buffered, switch to scheduled processing and tune `maximum number of results/cycles` to drain queue backlog.

## Webhook Behavior Caveats
- Webhooks are queued per webhook endpoint.
- Default response without a `Webhook response` module is:
  - `200 Accepted` when queued
  - `400` when webhook queue is full
  - `429` when webhook rate limit checks fail
- Make webhook ingest limit is documented as up to 300 requests per 10-second interval.
- Queue capacity is plan-dependent (documented guidance: up to 667 per webhook per 10k monthly credits, capped at 10,000).
- Place `Webhook response` last unless you intentionally acknowledge early and accept reduced failure visibility.

## Retries and Error Handling
- For transport failures (`ConnectionError`, `ModuleTimeoutError`, `RateLimitError`), rely on Make incomplete execution retry/backoff behavior.
- Backoff schedule uses increasing delays (1m, 10m, 10m, 30m, 30m, 30m, 3h, 3h).
- Keep module-level error handlers for dead-letter publication on non-retryable failures.
- Make retries incomplete executions in batches (max 3 retries in parallel per scenario).

## History and Versioning Constraints
- There is no scenario undo; use manual saves plus Version History.
- Version History restore window is documented as up to 60 days for manually saved versions.
- Run Replay reuses trigger data with the current scenario version, consumes credits, and is bounded by run-history retention on plan.

## Contract and Approval Semantics
- Preserve canonical contract mapping (`gtm_event_v1`) before routing.
- Approval remains a hard gate: no outbound mutation without `approved`.
- Non-approved outcomes only emit deferred/blocked signals and notifications.
