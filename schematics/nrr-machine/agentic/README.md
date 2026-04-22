# Agentic Adapter (nrr-machine)

## Placeholder
- Define tool inventory and permission model.
- Include deterministic guardrails for contract validation.
- Add runbook steps for failure classification and retry policy.

## Required Context
- Include Endgame context/tool access via Endgame MCP and `endgame-cli`.
- Include CRM/system context via Salesforce Headless 360-compatible API/MCP/CLI access.

## Approval Gate
- Route SFDC write operations and outbound email actions through `approval_loop` before execution.
