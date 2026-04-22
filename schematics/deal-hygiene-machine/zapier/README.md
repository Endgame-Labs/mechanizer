# Zapier Adapter (deal-hygiene-machine)

## Placeholder
- Add zap template metadata as `zap.template.json`.
- Document trigger app/event and action app/event mappings.
- Confirm all required contract fields are present before actions.

## Required Context
- Include Endgame context/tool access via Endgame MCP and `endgame-cli`.
- Include CRM/system context via Salesforce Headless 360-compatible API/MCP/CLI access.

## Approval Gate
- Route SFDC write operations and outbound email actions through `approval_loop` before execution.
