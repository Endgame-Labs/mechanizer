# Claude Routines Runtime (deal-hygiene-machine)

## Purpose
Concrete runtime implementation guide for deal hygiene detection/remediation in Claude routines with strict approval-gated writes.

## Runtime Shape
- Cloud routine execution; autonomous session behavior.
- Trigger mix:
  - API for event-driven hygiene checks.
  - Schedule for backfill and drift sweeps.
  - Optional GitHub trigger when hygiene policies are repo-managed.

## Tool and MCP Wiring
- Context:
  - `endgame_mcp`, `salesforce_headless_360`, optional conversation tools.
- Decisioning:
  - scoring reasoner + directive policy checker.
- Side effects:
  - `sfdc_writeback`, `task_create`, `event_emitter`.

## Approval Checkpoints
- `approval_loop` is mandatory before **any** SFDC writeback.
- If approval is not `approved`, emit deferred event and skip mutation tools.

## External API/MCP Notes
- API `/fire` payload arrives as freeform `text`; parse/validate before stageing.
- Keep write-capable MCP servers available only to execution path.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
