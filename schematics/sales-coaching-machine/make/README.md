# Make Adapter (sales-coaching-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario artifact for Make import.
- Blueprint import/save limit is 2 MB; split large helper logic into callable cogs if needed.

## Implementation Pattern
1. Receive `call.completed` through `Webhooks > Custom webhook`.
2. Normalize payload to canonical `gtm_event_v1`.
3. Fetch context and run directive-alignment cog.
4. Request explicit human/system approval for outward actions.
5. Approved route creates coaching task.
6. Non-approved route sends manual-review escalation only.
7. Emit output event and dead-letter failures with canonical metadata.

## Webhook and Scheduling Caveats
- Instant webhook processing is parallel by default.
- Turn on sequential processing when call events for the same seller/opportunity must preserve order.
- Without explicit `Webhook response`, default behavior is queue accept/reject semantics (`200/400/429`).
- Documented webhook ingest rate limit is up to 300 requests per 10 seconds.
- For bursty sources, combine scenario run rate limits and queue draining settings to avoid downstream API spikes.

## Retry and Recovery Model
- Use incomplete executions + automatic retry for transport/rate-limit failures.
- Make backoff delays progress from minutes to hours across attempts.
- Keep module-level dead-letter routing for non-retryable validation/policy failures.
- If using `Webhook response`, place it at the end of route unless early ACK is required.

## History and Version Control Constraints
- Save scenario versions frequently; there is no direct undo.
- Version history restore is limited (documented 60-day window for manually saved versions).
- Run Replay can retest/backfill using prior trigger payloads, but consumes credits and depends on history retention.

## Contract and Approval Semantics
- `gtm_event_v1` normalization happens before any policy logic.
- Approval remains a required gate before Salesforce or Slack side effects.
- Rejected/timeout outcomes remain observable-only with explicit blocked/deferred signaling.
