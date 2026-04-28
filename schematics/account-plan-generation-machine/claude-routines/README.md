# Claude Routines Runtime (account-plan-generation-machine)

![Account Plan Generation Machine Diagram](../diagram.svg)

## Purpose
Run repeatable account-plan generation in Claude routines with explicit policy and approval controls for CRM/document writes.

## Runtime Shape
- Cloud routine execution, autonomous session semantics.
- Trigger mix:
  - Schedule for coverage refresh cohorts.
  - API for on-demand plan regeneration.
  - Optional GitHub trigger when plans are persisted as repo artifacts.

## Tool and MCP Wiring
- Context tools:
  - `endgame_mcp`, `salesforce_headless_360`, product telemetry/BI readers.
- Generation tools:
  - `plan_section_generator`, `whitespace_analyzer`, `directive_alignment`.
- Action tools:
  - `plan_doc_upsert`, `crm_plan_fields_update`, `event_emitter`.

## Approval Checkpoints
- Always gate `plan_doc_upsert` and CRM mutation with `approval_loop`.
- If approval is denied/expired, emit `account.plan.blocked` and leave generated draft in review state.

## External API/MCP Notes
- API routine `text` should carry run context (for example account list, reason for rerun).
- Configure only required MCP connectors for this routine to reduce injection and overreach risk.

## Interoperability Note
When handing off from ChatGPT Workspace Agents or other runtimes into Claude routines (or back), preserve `gtm_event_v1` as the event envelope contract for all ingress/egress boundaries.

## References
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/sub-agents
