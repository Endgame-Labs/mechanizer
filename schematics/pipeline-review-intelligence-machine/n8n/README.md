# n8n Adapter (pipeline-review-intelligence-machine)

Contract-first n8n adapter for `pipeline-review-intelligence-machine` using `gtm_event_v1`.

## Artifact
- `workflow.json`: importable reference workflow.

## Mapping Notes
- Trigger: webhook or scheduler bridge payload mapped to `gtm_event_v1`.
- Supported event types:
  - `pipeline.review.requested`
  - `deal.updated`
  - `activity.logged`
- Approval gate is mandatory before manager summary send or mutation actions.

## Smart-Cog Order
1. `enrich_account_health`
2. `deal_score_reasoner`
3. `directive_alignment`
4. `compose_outreach_message`
5. `route_exec_alert`
6. `approval_loop`

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
