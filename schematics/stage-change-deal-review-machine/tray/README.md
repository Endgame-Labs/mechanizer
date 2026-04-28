# Tray Adapter (stage-change-deal-review-machine)

![Stage Change Deal Review Machine Diagram](../diagram.svg)

Tray implementation of stage-change review with strict idempotency and approval-gated writebacks.

## Reference Artifact
- `workflow.json`: starter blueprint with branch contracts.

## Trigger Mapping
- Callable trigger receives canonical `gtm_event_v1` stage-change events.
- Validate required keys before cog execution.

## Stages
1. `normalize_validate`
2. `idempotency_check`
3. `enrich_account_health`
4. `deal_score_reasoner`
5. `directive_alignment`
6. `route_exec_alert`
7. `approval_loop`
8. Approved branch: CRM writeback + writeback event
9. Findings branch: Slack findings + findings event

## Error and Retry Path
- Transient connector failures: automatic retries/backoff.
- Validation/policy failures: terminal findings-only or failed-validation output.

## Format Parity
- Compatibility posture: `workflow.json` tracks machine intent and step sequencing, but it is not the native Tray project/workflow export JSON envelope.
- Importability: reference scaffold, not fully importable as-is.
- Official docs/API examples: [Import / Export](https://tray.ai/documentation/platform/enterprise-core/lifecycle-management/import-export), [Projects API (import, requirements, preview, export)](https://tray.ai/documentation/developer/platform-apis/projects).
- Public template/community source: [Workflow Threading Template (Tray Library)](https://tray.ai/documentation/library/template/3a24d0a7-f940-4ac7-b455-6a11380fcde5-workflow-threading-template).
