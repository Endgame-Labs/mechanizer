# Claude Routines Runtime (nrr-machine)

## Purpose
Runtime implementation for NRR intervention selection and execution in Claude routines with strict approval gates for outbound/CRM actions.

## Runtime Shape
- Autonomous cloud sessions via routine triggers.
- Trigger mix:
  - Schedule for low/no-touch rescoring.
  - API for event-driven intervention.
  - Optional GitHub for playbook/template lifecycle.

## Tool and MCP Wiring
- Context:
  - `endgame_mcp`, CRM (`salesforce_headless_360`), usage/billing readers.
- Decisioning:
  - risk + expansion score tools, directive alignment.
- Actions:
  - outbound messaging, CRM updates, alert routing, event emit.

## Approval Checkpoints
- `approval_loop` required before:
  - outbound email/sequence delivery.
  - commercial-impact CRM field updates.
- Denied/expired approvals emit blocked event and halt side effects.

## External API/MCP Notes
- API trigger uses per-routine bearer token and `/fire` endpoint.
- Keep API payload in `text`; routine parses/marshals into `attributes`.

## ChatGPT Workspace Interoperability Note (Apr 22, 2026)
- Claude routines can hand off post-decision or blocked-action events to a ChatGPT Workspace Agent for operator workflow continuation.
- Keep the cross-runtime contract envelope fixed at `gtm_event_v1` and carry forward the same `event_id`/`trace` lineage.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
