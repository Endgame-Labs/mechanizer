# Tray Adapter (ai-sdr-outbound-machine)

Tray runtime for `ai-sdr-outbound-machine` combining deterministic outbound workflowing with smart-cog reasoning checkpoints and approval before execution.

## Artifact
- `workflow.placeholder.json`: Tray workflow artifact (kept at current filename for compatibility).

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

## References
- Callable trigger: https://tray.ai/documentation/connectors/trigger/callable-trigger
- Call workflow: https://tray.ai/documentation/connectors/core/call-workflow
- Callable response: https://tray.ai/documentation/connectors/core/callable-workflow-response
- Manual error handling: https://tray.ai/documentation/platform/automation-integration/building-workflows/error-handling/manual-error-handling
