# Claude Routines Runtime (meeting-prep-brief-machine)

![Meeting Prep Brief Machine Diagram](../diagram.svg)

## Purpose
Run pre-meeting brief generation in Claude routines with explicit quality, policy, and delivery approval controls.

## Runtime Shape
- Cloud routine execution for unattended prep delivery.
- Trigger mix:
  - Schedule for upcoming-meeting sweeps.
  - API for urgent manual regenerate.
  - Optional GitHub trigger for template updates/tests.

## Tool and MCP Wiring
- Read/context tools:
  - calendar reader, endgame context, CRM snapshot, transcript/signal reader.
- Generation tools:
  - brief composer + directive alignment.
- Delivery tools:
  - `slack_send`, `email_send`, `event_emitter`.

## Approval Checkpoints
- `approval_loop` required before outbound delivery for:
  - executive briefs
  - high-severity risk briefs
  - any brief containing sensitive escalation content
- Non-executive low-risk briefs can auto-deliver if policy permits.

## External API/MCP Notes
- API `text` can include meeting ID + urgency note; parse and map into attributes.
- Keep connector set narrow; remove write connectors not used by delivery branch.

## Interoperability Note
When handing off from ChatGPT Workspace Agents or other runtimes into Claude routines (or back), preserve `gtm_event_v1` as the event envelope contract for all ingress/egress boundaries.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
