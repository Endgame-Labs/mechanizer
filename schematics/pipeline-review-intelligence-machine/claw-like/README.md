# Claw-like Adapter (pipeline-review-intelligence-machine)

`claw-like` is the scheduled runtime mode for weekly pipeline review prep in non-visual environments.

## Required Files
- `HEARTBEAT.md`: schedule and liveness contract.

## Runtime Model
1. Read cron schedule and timezone from `HEARTBEAT.md`.
2. Start one run per due tick (no overlap).
3. Execute canonical stages:
- collect pipeline candidates
- evaluate stale/missing-next-step/single-threading signals
- compose manager summary
- route critical flags
- pass outbound actions through `approval_loop`
4. Emit heartbeat after terminal event emission.

## Safe-Mode Behavior
- On stale transitions or dependency degradation:
- continue read-only scoring/summarization
- suppress outbound sends and mutations
- emit `pipeline_review_intelligence.machine.safe_mode`
