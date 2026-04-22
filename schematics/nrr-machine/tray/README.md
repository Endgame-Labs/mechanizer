# Tray Adapter (nrr-machine)

Tray runtime for `nrr-machine` focused on low-touch/no-touch account motion with approval-gated outbound and CRM updates.

## Artifact
- `workflow.json`: importable Tray project workflow artifact.

## Runtime Shape
1. Callable Trigger (`Trigger and respond`) accepts `gtm_event_v1`.
2. Optional Scheduled Trigger runs periodic segment sweeps (every 6h).
3. Normalize + dedupe (`Data Storage`, `Project` scope).
4. `Call workflow` smart cogs:
- context enrichment (Endgame + CRM + telemetry)
- risk/NRR scoring
- play selection
- outbound draft generation
5. `shared_approval_loop` callable gate before any outbound or CRM write.
6. Approved branch executes low/no-touch plays.
7. Blocked branch emits no-touch block event and exits safely.

## HITL and Compliance
- Approval is mandatory for:
- outbound email/send steps
- Salesforce renewal/opportunity updates
- Timeouts/rejections produce `nrr.play.blocked` only.

## Reliability
- Idempotency key: `event_id`.
- Manual error handling for side-effect connectors.
- Dead-letter payload includes `workflow_uuid`, `step_name`, `step_log_url`, `trace_id`.
- Prefer callable child workflows for heavy fan-out/fan-in to keep parent run stable.

## SDLC
- Promote with Tray Project versions + export/import.
- Use Import Requirements and Import Preview before target import.
- Keep auth/config mappings explicit per environment.

## References
- Composable workflows: https://tray.ai/documentation/platform/automation-integration/building-workflows/composable-workflows/calling-other-workflows
- Callable trigger: https://tray.ai/documentation/connectors/trigger/callable-trigger
- Scheduled trigger: https://tray.ai/documentation/connectors/triggers/scheduled-trigger/
- Data Storage: https://tray.ai/documentation/connectors/core/data-storage
- Manual error handling: https://tray.ai/documentation/platform/automation-integration/building-workflows/error-handling/manual-error-handling
- Projects API: https://tray.ai/documentation/developer/platform-apis/projects
