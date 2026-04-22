# n8n Adapter (deal-hygiene-machine)

## Placeholder
- Add exported workflow JSON as `workflow.json`.
- Map trigger payload to `gtm_event_v1` at entry node.
- Emit normalized output event before terminal action nodes.

## Required Context
- Include Endgame context/tool access via Endgame MCP and `endgame-cli`.
- Include CRM/system context via Salesforce Headless 360-compatible API/MCP/CLI access.

## Approval Gate
- Route SFDC write operations and outbound email actions through `approval_loop` before execution.
