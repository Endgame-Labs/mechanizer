# Tray Adapter (account-health-audit-machine)

![Account Health Audit Machine Diagram](../diagram.svg)

Tray runtime for `account-health-audit-machine` with scheduled and callable execution modes, reusable audit smart cogs, and approval-gated write actions.

## Artifact
- `workflow.json`: Tray workflow artifact (kept at current filename for compatibility).

## Runtime Flow
1. Scheduled trigger runs weekday audit cycles; callable trigger handles on-demand audits.
2. Normalize + dedupe by `event_id`.
3. Run reusable callable smart cogs:
- context enrichment
- health/risk scoring
- directive alignment
- remediation recommendation composition
4. If remediation includes outbound or CRM updates, run approval loop.
5. Emit terminal audit event with rationale and suggested actions.

## Operational Guidance
- Keep state in Data Storage with narrowest scope needed.
- For high-volume loops, use callable child workflows for parallelism and isolation.
- Manual error handling for Salesforce and outbound connector steps.


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
