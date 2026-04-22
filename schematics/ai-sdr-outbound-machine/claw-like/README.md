# Claw-like Adapter (ai-sdr-outbound-machine)

Heartbeat-runner mode for recurring SDR outbound refresh and response-qualification routing without visual workflow dependencies.

## Concrete Runtime Behavior
- Every 15 minutes, poll newly eligible prospects and response events.
- Execute canonical stages:
1. Normalize input to `gtm_event_v1`.
2. Enrich context and score qualification.
3. Draft personalized sequence.
4. Run directive alignment + approval gate.
5. Execute approved sequence/CRM operations.
6. Route qualified responses.
7. Emit output event + heartbeat metadata.

## Required Files
- [`HEARTBEAT.md`](./HEARTBEAT.md): schedule, stale policy, ownership, and alerts.

## Operator Notes
- Cursor key: `last_successful_occurred_at`.
- Idempotency key: `event_id`.
- Safe mode blocks outbound sends but continues scoring and diagnostics.
