# Tray Adapter (meeting-prep-brief-machine)

Tray runtime for `meeting-prep-brief-machine` that composes prep briefs from revenue context, then gates delivery via approval when the brief can drive outbound actions.

## Artifact
- `workflow.json`: Tray workflow artifact (kept at current filename for compatibility).

## Runtime Design
1. Callable Trigger ingests `gtm_event_v1` (parent orchestrator).
2. Optional Scheduled Trigger (`*/15 * * * *`) for upcoming-meeting polling mode.
3. Normalize + idempotency guard.
4. Compose prep package through callable smart cogs:
- context enrichment
- prep scoring
- brief composition
5. Run `shared_approval_loop` before Slack/email delivery for high-impact briefs.
6. Branch:
- approved: deliver brief to channels
- blocked: emit blocked event only

## Operational Notes
- Keep side-effect connectors (`slack`, `email`, `crm`) on manual error handling.
- Use Data Storage `Project` scope for event-level dedupe.
- Keep large meeting/transcript blobs out of Data Storage key limits.


## Format Parity
- Compatibility posture: `workflow.json` tracks machine intent and step sequencing, but it is not the native Tray project/workflow export JSON envelope.
- Importability: reference scaffold, not fully importable as-is.
- Official docs/API examples: [Import / Export](https://tray.ai/documentation/platform/enterprise-core/lifecycle-management/import-export), [Projects API (import, requirements, preview, export)](https://tray.ai/documentation/developer/platform-apis/projects).
- Public template/community source: [Workflow Threading Template (Tray Library)](https://tray.ai/documentation/library/template/3a24d0a7-f940-4ac7-b455-6a11380fcde5-workflow-threading-template).

## References
- Scheduled trigger: https://tray.ai/documentation/connectors/triggers/scheduled-trigger/
- Callable trigger: https://tray.ai/documentation/connectors/trigger/callable-trigger
- Data Storage: https://tray.ai/documentation/connectors/core/data-storage
- Manual error handling: https://tray.ai/documentation/platform/automation-integration/building-workflows/error-handling/manual-error-handling
