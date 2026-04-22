# n8n Adapter (stage-change-deal-review-machine)

Contract-first n8n adapter using `gtm_event_v1` for stage-progression review processing.

## Artifacts
- `workflow.json`: importable reference workflow.

## Triggering
- Primary trigger: `Webhook` (`POST`) for stage-change events.
- Supported `event_type` values:
  - `deal.stage_changed`
  - `opportunity.stage_changed`

## Smart-Cog Flow Mapping
1. Normalize + validate event envelope.
2. `enrich_account_health`.
3. `deal_score_reasoner`.
4. `directive_alignment`.
5. `route_exec_alert`.
6. `approval_loop` (mandatory before writeback).
7. Approved branch performs CRM writeback and emits writeback event.
8. Non-approved branch posts Slack findings and emits findings event.

## Idempotency and Retries
- Idempotency key: `event_id`.
- Retry transient HTTP and connector failures with backoff.
- Skip duplicate terminal events.

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
