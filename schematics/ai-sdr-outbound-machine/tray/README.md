# Tray Adapter (ai-sdr-outbound-machine)

![AI SDR Outbound Machine Diagram](../diagram.svg)

Tray runtime for `ai-sdr-outbound-machine` combining deterministic outbound workflowing with smart-cog reasoning checkpoints and approval before execution.

## Artifact
- `workflow.json`: Tray workflow artifact (kept at current filename for compatibility).

## Runtime Pattern
1. Callable Trigger receives outbound intent events.
2. Normalize into canonical machine contract.
3. Reusable callable smart cogs:
- lead/account enrichment
- qualification/routing score
- directive alignment + compliance check
- personalization draft builder
4. Approval loop required before sending outbound or mutating CRM records.
5. Approved path executes sequence/send/write actions.
6. Blocked path emits no-side-effect outcome event.

## Pluggable Integrations
- Research/context providers: Endgame MCP, Salesforce Headless 360, Exa/Perplexity/Parallel.
- Signals: Gong/Zoom call outcomes, product usage and intent events.
- Channel connectors: email/sales engagement + Slack notifications.

## Reliability
- Use Data Storage idempotency for duplicate suppression.
- Put outbound and CRM steps on connector-level manual error handling.
- Publish DLQ events with step log URL for review/replay.


## Format Parity
- Compatibility posture: `workflow.json` tracks machine intent and step sequencing, but it is not the native Tray project/workflow export JSON envelope.
- Importability: reference scaffold, not fully importable as-is.
- Official docs/API examples: [Import / Export](https://tray.ai/documentation/platform/enterprise-core/lifecycle-management/import-export), [Projects API (import, requirements, preview, export)](https://tray.ai/documentation/developer/platform-apis/projects).
- Public template/community source: [Workflow Threading Template (Tray Library)](https://tray.ai/documentation/library/template/3a24d0a7-f940-4ac7-b455-6a11380fcde5-workflow-threading-template).

## References
- Callable trigger: https://tray.ai/documentation/connectors/trigger/callable-trigger
- Call workflow: https://tray.ai/documentation/connectors/core/call-workflow
- Callable response: https://tray.ai/documentation/connectors/core/callable-workflow-response
- Manual error handling: https://tray.ai/documentation/platform/automation-integration/building-workflows/error-handling/manual-error-handling
