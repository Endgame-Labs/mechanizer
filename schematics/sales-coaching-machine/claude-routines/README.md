# Claude Routines Runtime (sales-coaching-machine)

## Purpose
Operational runtime guide for coaching recommendation generation with evidence checks and approval-gated CRM/task side effects.

## Runtime Shape
- Runs as unattended cloud routine sessions.
- Trigger mix:
  - API for call/deal events.
  - Schedule for manager digest generation.
  - Optional GitHub for rubric/template maintenance.

## Tool and MCP Wiring
- Context:
  - `endgame_mcp`, transcript/call insights, CRM read.
- Decisioning:
  - coaching scorer + directive alignment.
- Actions:
  - `create_salesforce_task`, manager notification, `event_emitter`.

## Approval Checkpoints
- `approval_loop` required before CRM task creation or outbound manager notifications that change workflow state.
- Rejected/expired -> emit `coaching.recommendation.blocked` and route to review queue.

## External API/MCP Notes
- API trigger body `text` should include call/opportunity refs; parser resolves IDs.
- Restrict MCP servers so research tools are separate from write tools.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
