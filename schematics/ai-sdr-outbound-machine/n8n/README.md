# n8n Adapter (ai-sdr-outbound-machine)

![AI SDR Outbound Machine Diagram](../diagram.svg)

n8n implementation for SDR outbound research, personalized drafting, approval-gated execution, and qualified-response routing.

## Artifacts
- `workflow.json`: importable workflow reference.

## Format Parity
- Importable workflow JSON: Yes (`workflow.json` is valid JSON and follows n8n workflow export object shape).
- Required top-level keys: Present (`name`, `nodes`, `connections`).
- Parity references:
  - Official n8n export/import docs: https://docs.n8n.io/workflows/export-import/
  - Community/open workflow source: https://n8n.io/workflows/

## Triggering
- Primary trigger: `Webhook` for machine events.
- Supported event types:
  - `prospect.research_requested`
  - `account.intent_detected`
  - `response.received`

## gtm_event_v1 Mapping
- Normalize trigger payload to:
  - `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`
  - `trace.trace_id`
  - `subject`
  - `attributes` (account/persona/owner/response metadata)

## Smart-Cog Flow Mapping
1. Normalize + validate.
2. `enrich_account_health`.
3. `deal_score_reasoner`.
4. `directive_alignment`.
5. `compose_outreach_message`.
6. `route_exec_alert`.
7. `approval_loop`.
8. `Approved?` gate branches terminal behavior.
9. Approved branch emits `sdr.sequence.ready` or `sdr.response.routed` based on source event type.
10. Non-approved branch emits `sdr.sequence.blocked`.

## Error Handling
- Enable retries for API calls.
- Use `event_id` as idempotency key for side effects.
- Configure an Error Trigger workflow for dead-letter and alerts.
- Webhook is configured with `onReceived` response mode to avoid response-node deadlocks for unsupported events.

## References
- n8n Webhook node: https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/
- n8n Schedule Trigger node: https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.scheduletrigger/
- n8n HTTP Request node: https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/
- n8n Code node: https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.code/
- n8n Error handling / Error Trigger: https://docs.n8n.io/flow-logic/error-handling/
- n8n Queue mode scaling: https://docs.n8n.io/hosting/scaling/queue-mode/
- n8n credentials: https://docs.n8n.io/credentials/
- n8n import/export workflows: https://docs.n8n.io/workflows/export-import/
- n8n source control environments: https://docs.n8n.io/source-control-environments/
- n8n Salesforce node: https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.salesforce/
- n8n Slack node: https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.slack/
