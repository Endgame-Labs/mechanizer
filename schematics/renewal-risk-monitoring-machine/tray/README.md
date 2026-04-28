# Tray Adapter (renewal-risk-monitoring-machine)

![Renewal Risk Monitoring Machine Diagram](../diagram.svg)

## Artifact
- `workflow.json`

## Trigger Design
- Scheduled trigger at 07:00 PT for daily renewal-near account sweep.
- Optional callable trigger for event-driven runs.

## Contract Semantics
1. Validate `gtm_event_v1`.
2. Build recommended play from risk signals.
3. Send CSM Slack alert.
4. Route high-severity exec alert.
5. Execute only approved optional actions.

## Format Parity
- Compatibility posture: `workflow.json` tracks machine intent and step sequencing, but it is not the native Tray project/workflow export JSON envelope.
- Importability: reference scaffold, not fully importable as-is.
- Official docs/API examples: [Import / Export](https://tray.ai/documentation/platform/enterprise-core/lifecycle-management/import-export), [Projects API (import, requirements, preview, export)](https://tray.ai/documentation/developer/platform-apis/projects).
- Public template/community source: [Workflow Threading Template (Tray Library)](https://tray.ai/documentation/library/template/3a24d0a7-f940-4ac7-b455-6a11380fcde5-workflow-threading-template).
