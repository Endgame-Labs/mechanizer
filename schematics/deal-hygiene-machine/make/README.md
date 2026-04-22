# Make Adapter (deal-hygiene-machine)

## Placeholder
- Add scenario blueprint as `scenario.placeholder.json`.
- Document module-level mappings to/from shared contracts.
- Capture error routes and dead-letter handling.

## Required Context
- Include Endgame context/tool access via Endgame MCP and `endgame-cli`.
- Include CRM/system context via Salesforce Headless 360-compatible API/MCP/CLI access.

## Approval Gate
- Route SFDC write operations and outbound email actions through `approval_loop` before execution.
