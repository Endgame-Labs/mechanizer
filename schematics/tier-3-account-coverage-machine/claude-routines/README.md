# Claude Routines Runtime (tier-3-account-coverage-machine)

## Purpose
Run scalable tier-3 account monitoring and actioning in Claude routines with explicit approval before outbound and CRM mutations.

## Runtime Shape
- Works best as schedule-first routine with optional API trigger.
- Trigger mix:
  - Schedule for cohort sweeps.
  - API for urgent account intervention.

## Tool and MCP Wiring
- Context:
  - `endgame_mcp`, CRM, usage/billing/support signals.
- Decisioning:
  - health enrichment, play scoring, directive alignment.
- Actions:
  - outreach drafting/sending, CRM updates, escalation routing.

## Approval Checkpoints
- `approval_loop` is mandatory before any outbound message send or CRM write.
- Approved branch executes actions; all other decisions emit blocked state.

## External API/MCP Notes
- API `text` should carry account identifiers + event summary.
- Keep MCP write tools restricted to execution stage and relevant accounts.

## Claude <-> ChatGPT Workspace Agent Interoperability
- Claude routines and Workspace Agents interoperate through the same `gtm_event_v1` envelope; no adapter-specific payload drift is allowed.
- Handoffs between runtimes must preserve `event_id`, `trace.trace_id`, subject identity, and approval state.
- If one runtime drafts and the other executes, enforce the same `approval_loop` contract before outbound or CRM side effects.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
