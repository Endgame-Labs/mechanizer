# Tray Adapter (new-hire-ramp-accelerator-machine)

Tray starter for new-hire-ramp-accelerator-machine with callable ingestion and mandatory approval gate.

## Artifact
- `workflow.json`

## Flow Contract
1. Validate `gtm_event_v1` input.
2. Dedupe by `event_id`.
3. Build onboarding package sections: territory snapshot, starter accounts, messaging kit, week-one plan.
4. Request approval.
5. Approved branch writes package + CRM tasks and emits `rep.onboarding.package_generated`.
6. Blocked branch emits `rep.onboarding.package_blocked` and performs no mutations.

## Format Parity
- Compatibility posture: `workflow.json` tracks machine intent and step sequencing, but it is not the native Tray project/workflow export JSON envelope.
- Importability: reference scaffold, not fully importable as-is.
- Official docs/API examples: [Import / Export](https://tray.ai/documentation/platform/enterprise-core/lifecycle-management/import-export), [Projects API (import, requirements, preview, export)](https://tray.ai/documentation/developer/platform-apis/projects).
- Public template/community source: [Workflow Threading Template (Tray Library)](https://tray.ai/documentation/library/template/3a24d0a7-f940-4ac7-b455-6a11380fcde5-workflow-threading-template).
