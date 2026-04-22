# Claw-like Adapter (sales-coaching-machine)

Scheduled `claw-like` runtime for coaching checks and digest generation when no visual workflow platform is used.

## Runtime Model
1. Resolve cadence and liveness from `HEARTBEAT.md`.
2. Enforce one active run at a time to avoid duplicate task creation.
3. Every 15 minutes, poll `call.completed` in the prior 20-minute lookback window.
4. For each event:
1. normalize to `gtm_event_v1`
2. enrich with Endgame and CRM context
3. run directive alignment evaluation
4. create coaching task only when alignment passes and idempotency key is new
5. emit `coaching.recommendation.created`
5. Weekdays at 5:00 PM local time, build manager digest for unresolved `needs_review` items.

## Required Files
- [`HEARTBEAT.md`](./HEARTBEAT.md): schedule, ownership, stale policy.
- Optional local runtime config:
- `workflow.yaml` for command wiring
- `state-store.md` for cursor/checkpoint strategy

## Approval and Exec Safety
- Any side effects outside local state (email send, CRM write, ticket creation) pass through approval gate first.
- Approval behavior follows OpenClaw safety interlock: policy + allowlist + explicit approval must all allow.
- If approval UI is unreachable for a prompt-required action, action result is deny by fallback and is not executed.
- Approval timeout is a denied outcome and is recorded with reason.

## Safe-Mode Behavior
- Trigger safe mode on stale state, repeated dependency failures, or approval subsystem outage.
- In safe mode:
- continue polling and analysis
- suppress auto-task creation and outbound side effects
- emit recommendations as `needs_review`
- continue digest generation with safe-mode annotation
- Auto-exit safe mode only after one fully successful run.

## Retry Policy
- Poll/enrichment transient failures: 3 retries (10s, 30s, 90s).
- Alignment service transient failures: 2 retries (15s, 45s).
- Approval transport transient failures: 2 retries (10s, 30s).
- Non-retryable: malformed input, contract validation errors, policy denies, approval timeout.

## Operator Notes
- Cursor key: `last_successful_occurred_at`.
- Replays allowed for 24h keyed by `event_id`.
- Emit run telemetry: `expected_tick_at`, `started_at`, `finished_at`, `processed_count`, `created_count`, `denied_count`, `safe_mode`.
