# n8n Adapter (renewal-risk-monitoring-machine)

## Artifacts
- `workflow.json`: importable starter workflow.

## Triggering
- `Schedule Trigger` daily at 07:00 America/Los_Angeles.
- Optional `Webhook` trigger for ad hoc event ingestion.

## Flow Mapping
1. Build/ingest `gtm_event_v1`.
2. Validate + dedupe.
3. Enrich context and score renewal risk.
4. Compose recommended play for CSM.
5. Send Slack alert.
6. Route high-severity exec alert.
7. Run approval for optional actions and emit terminal event.

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
