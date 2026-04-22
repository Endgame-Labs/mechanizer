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

## Claude Routine Interoperability
- Claude routines remain interoperable with ChatGPT Workspace Agents by preserving canonical `gtm_event_v1` envelopes between runtimes.
- Handoff contract:
  - Claude routine output emits `gtm_event_v1` with stable `event_id`, `trace`, `subject`, and stage-review `attributes`.
  - ChatGPT Workspace Agent intake consumes the same `gtm_event_v1` payload for findings continuation, approval resume, or replay-safe completion.
- This keeps cross-provider stage-review execution deterministic, auditable, and idempotent.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
