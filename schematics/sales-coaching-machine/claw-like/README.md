# Claw-like Adapter (sales-coaching-machine)

`claw-like` is used for stateful or continuously scheduled orchestration.

## Required Files
- `HEARTBEAT.md`: machine liveness and schedule contract.
- Optional runtime assets (`workflow.yaml`, `state-store.md`, etc.).

## Runtime Expectations
- Scheduler must honor the cron and timezone defined in HEARTBEAT.
- Each successful run must emit a heartbeat signal with machine ID and timestamp.

## Required Context
- Include Endgame context/tool access via Endgame MCP and `endgame-cli`.
- Include CRM/system context via Salesforce Headless 360-compatible API/MCP/CLI access.
