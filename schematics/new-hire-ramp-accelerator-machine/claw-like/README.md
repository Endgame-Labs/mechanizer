# Claw-like Adapter (new-hire-ramp-accelerator-machine)

`claw-like` is the heartbeat-runner mode for provisioning and reconciliation onboarding package generation.
`HEARTBEAT.md` is the source of truth for cadence, liveness, and stale behavior.

## Runtime Model
1. Parse `schedule_cron` and `timezone` from `HEARTBEAT.md`.
2. Run provisioning catch-up with overlap protection.
3. Assemble onboarding package per in-scope rep.
4. Enforce approval gate before side effects.
5. Emit output events and final heartbeat on success.
