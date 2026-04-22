# Claude Routines Adapter (nrr-machine)

## Placeholder
- Add deterministic routine specification in `routine.md`.
- Define guardrail checks and fallback behavior.
- Ensure prompt templates do not alter contract-required keys.

## Required Context
- Include Endgame context/tool access via Endgame MCP and `endgame-cli`.
- Include CRM/system context via Salesforce Headless 360-compatible API/MCP/CLI access.

## Approval Gate
- Route SFDC write operations and outbound email actions through `approval_loop` before execution.
