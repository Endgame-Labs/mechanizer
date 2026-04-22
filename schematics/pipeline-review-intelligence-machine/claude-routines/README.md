# Claude Routines Runtime (pipeline-review-intelligence-machine)

## Purpose
Runtime guidance for weekly pipeline review prep with deterministic checks and approval-gated mutation paths.

## Runtime Shape
- Claude cloud routine sessions, triggered by schedule/API.
- Typical trigger mix:
  - Schedule before manager pipeline review windows.
  - API for ad-hoc reruns after major stage churn.

## Tool and MCP Wiring
- Read/context:
  - CRM snapshots, endgame account context, activity timeline tools.
- Analysis:
  - stale deal checks, next-step gap detection, threading analysis, directive alignment.
- Actions:
  - `manager_summary_publish`, optional `crm_hygiene_update`, `event_emitter`.

## Approval Checkpoints
- If routine performs CRM mutations or outbound manager notifications with workflow impact, require `approval_loop`.
- Read-only prep reports can run without approval.

## External API/MCP Notes
- API `text` should include review window or manager scope.
- Keep MCP servers scoped to pipeline review context and outputs.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
