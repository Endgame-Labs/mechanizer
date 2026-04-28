# Tray Adapter (deal-hygiene-machine)

![Deal Hygiene Machine Diagram](../diagram.svg)

Tray runtime for `deal-hygiene-machine` using composable callable workflows, deterministic policy checks, and an approval-gated Salesforce write path.

## Artifact
- `workflow.json`: Tray project workflow artifact for import/export promotion.

## Tray Runtime Design
1. **Callable Trigger** (`Trigger and respond`) receives canonical `gtm_event_v1`.
2. Validate + normalize payload with Script + Boolean/Branch logic.
3. Use `Call workflow` (`Fire and wait for response`) for reusable smart cogs:
- `context_enrichment_cog`
- `deal_scoring_cog`
- `directive_alignment_cog`
4. Draft mutation plan (`CloseDate`, `NextStep`, stage notes).
5. Run `approval_loop_cog` as a callable child workflow.
6. Branch on approval outcome:
- `approved`: write to Salesforce + emit `deal.hygiene.remediated`
- `blocked`: emit `deal.hygiene.deferred` (no CRM mutation)

## Idempotency and State
- Use `Data Storage` key `deal-hygiene:{event_id}` at `Project` scope.
- Guard against duplicate event replay before side effects.
- Store terminal status and approval decision.
- Never store secrets in Data Storage (visible in logs); use Tray authentications / `$.auth`.

## Error Handling
- Default: workflow-level error handling for transient connector errors.
- High-risk steps (`salesforce.update_record`, outbound notifications): connector-level **Manual error handling** with explicit failure branch.
- Failure branch writes dead-letter payload (`machine_id`, `event_id`, `trace_id`, `step_log_url`, connector error).

## SDLC / Promotion
1. Build/test in dev Project.
2. Create Project Version.
3. Export JSON from selected version.
4. Use Import Requirements + Import Preview for target workspace.
5. Import with auth/config mappings.
6. Create destination version and publish according to release policy.

## Approval/HITL rule
- Approval is required before any Salesforce update or external outbound action.


## Format Parity
- Compatibility posture: `workflow.json` tracks machine intent and step sequencing, but it is not the native Tray project/workflow export JSON envelope.
- Importability: reference scaffold, not fully importable as-is.
- Official docs/API examples: [Import / Export](https://tray.ai/documentation/platform/enterprise-core/lifecycle-management/import-export), [Projects API (import, requirements, preview, export)](https://tray.ai/documentation/developer/platform-apis/projects).
- Public template/community source: [Workflow Threading Template (Tray Library)](https://tray.ai/documentation/library/template/3a24d0a7-f940-4ac7-b455-6a11380fcde5-workflow-threading-template).

## References
- Callable workflows: https://tray.ai/documentation/platform/automation-integration/building-workflows/composable-workflows/calling-other-workflows
- Callable trigger: https://tray.ai/documentation/connectors/trigger/callable-trigger
- Callable response: https://tray.ai/documentation/connectors/core/callable-workflow-response
- Manual error handling: https://tray.ai/documentation/platform/automation-integration/building-workflows/error-handling/manual-error-handling
- Data Storage: https://tray.ai/documentation/connectors/core/data-storage
- Projects API (versions/import/export): https://tray.ai/documentation/developer/platform-apis/projects
