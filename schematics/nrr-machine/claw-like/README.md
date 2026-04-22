# Claw-like Adapter (nrr-machine)

`claw-like` is the scheduled runtime for `nrr-machine` when no visual flow orchestrator is used.
`HEARTBEAT.md` is the contract source for cadence, liveness, stale detection, and escalation.

## Runtime Model
1. Parse `schedule_cron` and `timezone` from `HEARTBEAT.md` and compute `expected_tick_at`.
2. Enforce one active run at a time (`run_lock=forbid-overlap`) so a delayed run cannot overlap the next tick.
3. Start run with immutable metadata: `run_id`, `machine_id`, `scheduled_for`, `started_at`.
4. Execute pipeline stages with stage-level checkpoints:
- discover candidate accounts
- normalize events to canonical contract
- compute no-touch/low-touch score decisions
- queue side-effect intents
- pass side-effect intents through approval gate
- execute approved actions only
- emit machine output events and heartbeat success
5. Mark run successful only if terminal heartbeat is emitted after pipeline completion.

## Approval and Exec Safety
- Irreversible actions (outbound email, Salesforce writes) are approval-gated and must not bypass policy.
- Follow OpenClaw exec-approval interlock semantics: policy + allowlist + approval decision must all allow execution.
- If a prompt-required action cannot reach an approval UI, fallback is deny (`askFallback=deny`) and the action is blocked.
- Approval timeout is a denied action outcome, not a silent success.
- Any denied or timed-out action is recorded with reason and never auto-promoted in the same run.

## Safe-Mode Behavior
- Enter safe mode when stale, on repeated transient failures, or after approval subsystem outage.
- In safe mode:
- continue discovery, normalization, and scoring
- suppress outbound email and Salesforce writes
- emit diagnostics (`nrr.machine.safe_mode`) with blocker reason and expiry
- Exit safe mode only after one full successful run with approval channel healthy.

## Retries
- Scheduler/bootstrap transient failures: 2 retries (10s, 30s).
- Account processing transient failures: 3 retries (5s, 20s, 60s).
- Approval transport transient failures: 2 retries (10s, 30s).
- Non-retryable classes: validation errors, policy denies, approval timeouts, contract incompatibility.

## Stale Handling
- `grace_period_seconds` allows normal scheduler jitter after each expected tick.
- If no successful heartbeat arrives within `stale_after_seconds`, transition to stale.
- On stale transition:
- emit `nrr.machine.stale`
- alert all `alert_channels`
- force safe mode (score-only) until recovery
- Clear stale only after one complete successful run and heartbeat emission.

## Operators
- Recommended checks:
- `openclaw cron list`
- `openclaw cron runs --id <job-id> --limit 20`
- `openclaw system heartbeat last`
- `openclaw approvals get`
