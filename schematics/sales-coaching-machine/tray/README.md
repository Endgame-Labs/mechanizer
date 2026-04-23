# Tray Adapter (sales-coaching-machine)

Tray runtime for `sales-coaching-machine` that evaluates post-call coaching recommendations against directives, then routes approved actions to CRM and manager channels.

## Artifact
- `workflow.json`: callable Tray workflow artifact.

## Runtime Flow
1. Callable Trigger ingests `call.completed` in `gtm_event_v1` envelope.
2. Normalize call/account/deal identifiers and trace metadata.
3. `Call workflow` smart cogs:
- context enrichment (Endgame + call transcript metadata)
- coaching recommendation generation
- directive alignment scoring
4. Branch on alignment confidence.
5. For actions with external side effects (manager notifications, CRM tasks), run `shared_approval_loop` first.
6. Emit `coaching.recommendation.created` terminal event + callable response.

## Approval/HITL
- Approval required when the machine will:
- send outbound manager-facing summaries
- write coaching tasks into Salesforce
- Low-risk internal-only scoring can run without approval.

## Reliability
- Idempotency key: `event_id`.
- Manual error handling for side-effect branches.
- Dead-letter branch emits `step_log_url` for replay/triage.
- Keep child cogs modular via callable workflows to simplify updates.


## Format Parity
- Compatibility posture: `workflow.json` tracks machine intent and step sequencing, but it is not the native Tray project/workflow export JSON envelope.
- Importability: reference scaffold, not fully importable as-is.
- Official docs/API examples: [Import / Export](https://tray.ai/documentation/platform/enterprise-core/lifecycle-management/import-export), [Projects API (import, requirements, preview, export)](https://tray.ai/documentation/developer/platform-apis/projects).
- Public template/community source: [Workflow Threading Template (Tray Library)](https://tray.ai/documentation/library/template/3a24d0a7-f940-4ac7-b455-6a11380fcde5-workflow-threading-template).

## References
- Callable workflows: https://tray.ai/documentation/platform/automation-integration/building-workflows/composable-workflows/calling-other-workflows
- Callable response: https://tray.ai/documentation/connectors/core/callable-workflow-response
- Manual error handling: https://tray.ai/documentation/platform/automation-integration/building-workflows/error-handling/manual-error-handling
- Conditional logic (Boolean/Branch): https://tray.ai/documentation/platform/advanced-tray-usage/conditional-logic/
- Projects API: https://tray.ai/documentation/developer/platform-apis/projects
