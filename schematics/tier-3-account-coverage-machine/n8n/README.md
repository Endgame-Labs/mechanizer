# n8n Adapter (tier-3-account-coverage-machine)

n8n adapter for low-touch long-tail coverage automation with mandatory approval before outbound and CRM side effects.

## Artifacts
- `workflow.json`: importable reference workflow.

## Triggering
- Realtime trigger: `Webhook` for canonical `gtm_event_v1` events.
- Batch trigger: `Schedule Trigger` every 6 hours for cohort refresh.

## gtm_event_v1 Contract Mapping
- Input contract: `gtm_event_v1`.
- Required checks: `event_id`, `event_type`, `source`, `occurred_at`, `trace.trace_id`, `subject.entity_id`.
- Output terminal events:
  - `tier3.coverage.executed`
  - `tier3.coverage.blocked`
  - `tier3.coverage.skipped_duplicate`
  - `tier3.coverage.failed`

## Smart-Cog Flow Mapping
1. Normalize + validate.
2. `enrich_account_health`.
3. Segment gate (`low_touch`, `no_touch`).
4. `deal_score_reasoner`.
5. `directive_alignment`.
6. `compose_outreach_message`.
7. `route_exec_alert`.
8. `approval_loop`.
9. Approved branch performs side effects and emits executed event.

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
