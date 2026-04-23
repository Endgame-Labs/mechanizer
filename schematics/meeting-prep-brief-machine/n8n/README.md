# n8n Adapter (meeting-prep-brief-machine)

n8n adapter for `meeting-prep-brief-machine` focused on reliable pre-meeting brief delivery with approval-gated delivery side effects.

## Artifacts
- `workflow.json`: importable reference workflow.

## Format Parity
- Importable workflow JSON: Yes (`workflow.json` is valid JSON and follows n8n workflow export object shape).
- Required top-level keys: Present (`name`, `nodes`, `connections`).
- Parity references:
  - Official n8n export/import docs: https://docs.n8n.io/workflows/export-import/
  - Community/open workflow source: https://n8n.io/workflows/

## Triggering
- Realtime trigger: `Webhook` for `meeting.scheduled`, `account.exec_meeting_booked`, `opportunity.stage_changed`.
- Batch trigger: `Schedule Trigger` every 15 minutes for near-term meeting sweep.

## gtm_event_v1 Contract Mapping
- Input contract: `gtm_event_v1`.
- Required checks: `event_id`, `event_type`, `source`, `occurred_at`, `trace.trace_id`, `subject.entity_id`.
- Output events:
  - `meeting.prep_brief.delivered`
  - `meeting.prep_brief.blocked`
  - `meeting.prep_brief.skipped_duplicate`
  - `meeting.prep_brief.failed`

## Smart-Cog Flow Mapping
1. `Normalize + Validate`
2. `enrich_account_health`
3. `deal_score_reasoner`
4. `directive_alignment`
5. `compose_outreach_message`
6. `route_exec_alert`
7. `approval_loop`
8. Deliver brief to Slack + inbox on approved branch

## Reliability Notes
- Use idempotency key `event_id` before delivery side effects.
- Keep approval node immediately before Slack and inbox send nodes.
- Attach Error Trigger workflow for failed-event emission and alerting.

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
