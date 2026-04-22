# Tray Adapter (nrr-machine)

## Placeholder
- Add workflow export metadata as `workflow.placeholder.json`.
- Specify callable trigger config and field transforms.
- Include retry/timeout settings that mirror machine SLO.

## Required Context
- Include Endgame context/tool access via Endgame MCP and `endgame-cli`.
- Include CRM/system context via Salesforce Headless 360-compatible API/MCP/CLI access.

## Approval Gate
- Route SFDC write operations and outbound email actions through `approval_loop` before execution.
