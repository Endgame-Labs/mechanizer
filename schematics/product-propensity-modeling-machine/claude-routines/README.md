# Claude Routines Runtime (product-propensity-modeling-machine)

## Purpose
Operational guidance for running `product-propensity-modeling-machine` as a Claude Code **routine** on Anthropic cloud sessions.

## Runtime Shape
- Runs autonomously in cloud routine sessions (no in-run permission prompts).
- Recommended triggers:
  - Schedule: six-hour score refresh (for example `0 */6 * * *`, org local timezone).
  - API: ad-hoc rerun from alerting/ops systems.
  - GitHub: optional if score output opens/updates calibration or documentation PRs.

## Tool and MCP Wiring
- Required read-path servers/tools:
  - `endgame_mcp` for account timeline + directives.
  - warehouse metrics reader (`snowflake`/`bigquery` MCP or internal API tool).
  - CRM read snapshot tool (`salesforce_headless_360` or equivalent).
- Optional action-path tools:
  - `slack_notify`, `email_send`, `crm_task_upsert`, `event_emitter`.
- Keep MCP scope minimal per routine; remove unused connectors in routine config.

## Approval Checkpoints
- `approval_loop` is **required** before any outbound communication or CRM/document mutation.
- Pure read + scoring + explanation generation can run without approval.
- Rejected/expired approvals must emit `product.propensity.blocked` and skip side effects.

## Implementation Notes
- Validate `gtm_event_v1` at stage 1.
- Treat API trigger `text` as freeform string; parse explicitly in routine logic.
- Preserve `trace.trace_id` through every external call.

## Claude <-> ChatGPT Workspace Agent Interoperability
- Interop between Claude routines and Workspace Agents must use `gtm_event_v1` only; avoid runtime-specific envelope fields.
- Preserve `event_id`, `trace.trace_id`, schedule metadata, score attributes, and evidence refs across runtime boundaries.
- If scoring and downstream execution are split across runtimes, enforce the same approval policy before any mutation side effects.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
