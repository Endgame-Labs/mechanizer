# Claw-like Adapter (account-plan-generation-machine)

`claw-like` is the heartbeat-runner mode for recurring and bulk account-plan generation.
`HEARTBEAT.md` is the source of truth for cadence, liveness, and stale behavior.

## Runtime Model
1. Parse `schedule_cron` and `timezone` from `HEARTBEAT.md`.
2. Run batch account-plan refresh with overlap protection.
3. Produce structured plan sections per account.
4. Enforce approval gate before side effects.
5. Emit output events and final heartbeat on success.
