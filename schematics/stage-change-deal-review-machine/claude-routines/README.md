# Claude Routines Runtime (stage-change-deal-review-machine)

## Purpose
Runtime guidance for stage-change review automation with explicit approval gating before any CRM mutation.

## Runtime Shape
- Claude cloud routine sessions from API or schedule triggers.
- Used for stage-change quality checks and controlled remediation.

## Tool and MCP Wiring
- Read/context:
  - CRM stage history, qualification evidence, directives context.
- Decisioning:
  - score reasoner + directive alignment.
- Actions:
  - findings publication, optional CRM writeback, event emitter.

## Approval Checkpoints
- `approval_loop` is the sole authorization path for CRM mutation.
- Non-approved branches may publish findings but must not mutate CRM state.

## External API/MCP Notes
- API `text` is freeform; map into validated event attributes.
- Keep write tools unavailable until post-approval execution branch.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
