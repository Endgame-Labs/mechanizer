# Claw-like Adapter (deal-hygiene-machine)

`claw-like` is the scheduled runtime for deal hygiene orchestration in non-visual environments.

## Required Files
- `HEARTBEAT.md`: machine liveness and schedule contract.
- Optional runtime assets (`workflow.yaml`, `state-store.md`, etc.).

## Runtime Model
1. Read `schedule_cron` and `timezone` from `HEARTBEAT.md`.
2. Enforce single in-flight run and create immutable `run_id` for each tick.
3. Execute canonical stages:
- collect candidate deals/opportunities
- normalize and validate records
- evaluate hygiene rules and generate remediation intents
- pass side-effect intents through approval loop
- execute approved updates and emit output events
4. Emit heartbeat only after full successful completion.

## Required Context
- Include Endgame context/tool access via Endgame MCP and `endgame-cli`.
- Include CRM/system context via Salesforce Headless 360-compatible API/MCP/CLI access.

## Approval Gate
- Route SFDC write operations and outbound email actions through `approval_loop` before execution.

## Approval and Exec Safety
- Enforce OpenClaw approval interlock behavior for host execution and high-risk actions.
- Prompt-required actions without reachable approval UI resolve to deny fallback and are not executed.
- Approval timeout is a denied action outcome.
- Denied or timed-out actions remain blocked for the current run and require a new run intent.

## Safe-Mode Behavior
- Enter safe mode when stale or when dependency health is degraded.
- In safe mode:
- continue reads, validation, and scoring
- suppress all outbound/SFDC write side effects
- emit `deal_hygiene.machine.safe_mode` with reason
- Exit safe mode after one full healthy run.

## Retry Policy
- Scheduler/bootstrap transient failures: 2 retries (10s, 30s).
- Data fetch/transform transient failures: 3 retries (5s, 20s, 60s).
- Approval transport transient failures: 2 retries (10s, 30s).
- Non-retryable: policy deny, approval timeout, validation/contract failures.

## Stale Handling
- Allow scheduler jitter via `grace_period_seconds`.
- Mark stale if no successful heartbeat within `stale_after_seconds`.
- On stale: alert all configured channels and force safe mode until recovery.
