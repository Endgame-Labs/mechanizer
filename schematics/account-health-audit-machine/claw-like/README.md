# Claw-like Adapter (account-health-audit-machine)

`claw-like` is used for cron-driven scheduled execution and liveness monitoring.

## Required Files
- `HEARTBEAT.md`: machine liveness and scheduling contract.

## Runtime Expectations
- Scheduler must honor cron and timezone in HEARTBEAT.
- Every successful run emits heartbeat with machine ID and timestamp.

## Required Context
- Endgame context access via Endgame MCP and `endgame-cli`.
- Warehouse/CRM/conversation data access via approved connectors.
