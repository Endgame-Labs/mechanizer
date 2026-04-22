# Tray Adapter (account-plan-generation-machine)

Tray runtime for `account-plan-generation-machine` using callable cogs for research, deterministic plan assembly, and approval-gated CRM/document writes.

## Artifact
- `workflow.placeholder.json`: Tray workflow artifact (kept at current filename for compatibility).

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

## References
- Callable workflows: https://tray.ai/documentation/platform/automation-integration/building-workflows/composable-workflows/calling-other-workflows
- Scheduled trigger: https://tray.ai/documentation/connectors/triggers/scheduled-trigger/
- Data Storage: https://tray.ai/documentation/connectors/core/data-storage
- Projects API: https://tray.ai/documentation/developer/platform-apis/projects
