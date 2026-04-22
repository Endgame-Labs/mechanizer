# Claude Routines Runtime (consumption-renewal-intervention-machine)

## Purpose
Runtime guidance for daily under-consumption renewal detection, intervention planning, and approval-gated execution.

## Runtime Shape
- Designed for schedule-first operation with optional API triggers.
- Typical triggers:
  - Schedule: daily sweep of renewal cohorts.
  - API: urgent intervention rerun from monitoring or CS tooling.

## Tool and MCP Wiring
- Read/context:
  - billing/usage signals, CRM renewal records, endgame account timeline.
- Decisioning:
  - intervention scoring + directive alignment.
- Actions:
  - `slack_notify` (always-on), plus optional mutation actions (`renewal_plan_update`, `csm_task_create`, `email_send`).

## Approval Checkpoints
- `approval_loop` required for all optional mutation actions.
- Slack summary may be allowed pre-approval if configured as non-mutating notification.
- Approval denial/timeout -> `cri.play.blocked_optional_actions`.

## External API/MCP Notes
- Keep API trigger payload in `text` concise: account ID(s), reason, urgency.
- Use least-privilege MCP connectors and isolate write tools to execution stage.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
