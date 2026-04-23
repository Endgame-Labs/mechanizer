# Tray Adapter (pipeline-review-intelligence-machine)

Tray implementation blueprint for weekly pipeline review prep and manager summary generation.

## Reference Artifact
- `workflow.json`: callable-trigger workflow blueprint with shared-cog sequencing.

## Contract Notes
- Inbound payload must normalize to `gtm_event_v1`.
- Approval gate is mandatory before outbound summary delivery or mutation operations.
- Terminal events should emit `pipeline.review.prep.completed|deferred|failed`.

## Format Parity
- Compatibility posture: `workflow.json` tracks machine intent and step sequencing, but it is not the native Tray project/workflow export JSON envelope.
- Importability: reference scaffold, not fully importable as-is.
- Official docs/API examples: [Import / Export](https://tray.ai/documentation/platform/enterprise-core/lifecycle-management/import-export), [Projects API (import, requirements, preview, export)](https://tray.ai/documentation/developer/platform-apis/projects).
- Public template/community source: [Workflow Threading Template (Tray Library)](https://tray.ai/documentation/library/template/3a24d0a7-f940-4ac7-b455-6a11380fcde5-workflow-threading-template).
