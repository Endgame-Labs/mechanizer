# Claude Routines Runtime (renewal-risk-monitoring-machine)

![Renewal Risk Monitoring Machine Diagram](../diagram.svg)

## Purpose
Runtime guide for daily renewal-risk monitoring with mandatory CSM visibility and approval-gated optional actions.

## Runtime Shape
- Schedule-first cloud routine with optional API trigger for urgent reruns.
- Common schedule: daily renewal-risk sweep by segment/region.

## Tool and MCP Wiring
- Read/context:
  - billing/usage risk features, CRM renewal data, endgame timeline context.
- Decisioning:
  - risk scoring + play selection + directive alignment.
- Actions:
  - mandatory `notify_csm_slack`, optional `crm_update`, `email_send`, `task_create`.

## Approval Checkpoints
- CSM notification path is mandatory and non-mutating.
- Optional outbound/CRM mutations require `approval_loop`.
- Denied/expired approvals emit blocked optional-actions outcome.

## External API/MCP Notes
- API `text` may carry alert details; parse into structured attributes before scoring.
- Limit write-capable connectors to execution stage only.

## ChatGPT Workspace Interoperability Note (Apr 22, 2026)
- For Claude-to-Workspace handoff, exchange only `gtm_event_v1` envelopes and preserve `event_id`, `trace`, and subject identity for deterministic continuation.
- Keep routine outputs contract-normalized so ChatGPT Workspace Agents can continue approval-gated paths without custom field translation.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
