# Claude Routines Runtime (new-hire-ramp-accelerator-machine)

## Purpose
Runtime guide for generating repeatable onboarding/ramp packages for new reps with explicit approval before publishing and CRM/task mutations.

## Runtime Shape
- Runs as Claude cloud routine sessions.
- Trigger mix:
  - Schedule for weekly ramp packet refresh.
  - API for on-demand packet generation from enablement/ops workflows.

## Tool and MCP Wiring
- Read/context:
  - rep profile source, territory/book data, directives from `endgame_mcp`, CRM read tools.
- Generation:
  - onboarding package composer + directive alignment.
- Actions:
  - `onboarding_doc_upsert`, `crm_task_create`, `slack_notify`, `event_emitter`.

## Approval Checkpoints
- `approval_loop` required before:
  - publishing ramp package to shared docs.
  - creating CRM tasks or sending manager-facing outbound notices.
- Non-approved outcomes emit `rep.onboarding.package_blocked`.

## External API/MCP Notes
- API `text` should include rep identifier + ramp context (start date, segment, team).
- Limit MCP connectors to onboarding-relevant systems only.

## ChatGPT Workspace Interoperability Note (Apr 22, 2026)
- For cross-runtime handoff to ChatGPT Workspace Agents, emit and consume `gtm_event_v1` only, preserving `event_id`, `trace`, and canonical subject fields for replay-safe continuation.
- Keep Claude routine outputs normalized to contract keys so Workspace runners can resume approval-gated execution without adapter-specific remapping.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
