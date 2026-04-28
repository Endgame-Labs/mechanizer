# Tray Adapter (account-plan-generation-machine)

![Account Plan Generation Machine Diagram](../diagram.svg)

Tray runtime for `account-plan-generation-machine` using callable cogs for research, deterministic plan assembly, and approval-gated CRM/document writes.

## Artifact
- `workflow.json`: Tray workflow artifact (kept at current filename for compatibility).

## Runtime Flow
1. Callable Trigger receives `gtm_event_v1`.
2. Optional scheduled sweep for strategic-account refresh.
3. Normalize + dedupe with Data Storage.
4. Build account plan sections via callable smart cogs:
- account context + relationships
- whitespace/opportunity map
- recommended plays and sequencing
5. Run shared approval loop for document publication + CRM note updates.
6. Approved branch publishes plan artifacts.
7. Blocked branch emits status event with no write side effects.

## Integration Pattern
- Provider calls should stay pluggable through `shared_context_enrichment` and `shared_plan_assembly` callable workflows.
- Typical provider set: Endgame MCP, Salesforce Headless 360, Gong/Zoom summaries, Seismic/Highspot enablement references.


## Format Parity
- Compatibility posture: `workflow.json` tracks machine intent and step sequencing, but it is not the native Tray project/workflow export JSON envelope.
- Importability: reference scaffold, not fully importable as-is.
- Official docs/API examples: [Import / Export](https://tray.ai/documentation/platform/enterprise-core/lifecycle-management/import-export), [Projects API (import, requirements, preview, export)](https://tray.ai/documentation/developer/platform-apis/projects).
- Public template/community source: [Workflow Threading Template (Tray Library)](https://tray.ai/documentation/library/template/3a24d0a7-f940-4ac7-b455-6a11380fcde5-workflow-threading-template).

## References
- Callable workflows: https://tray.ai/documentation/platform/automation-integration/building-workflows/composable-workflows/calling-other-workflows
- Scheduled trigger: https://tray.ai/documentation/connectors/triggers/scheduled-trigger/
- Data Storage: https://tray.ai/documentation/connectors/core/data-storage
- Projects API: https://tray.ai/documentation/developer/platform-apis/projects
