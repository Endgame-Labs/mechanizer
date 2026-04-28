# n8n Adapter (sales-coaching-machine)

n8n implementation for sales coaching signals from call events, with directive checks and approval-gated side effects.

## Artifacts
- `workflow.json`: importable workflow reference.

## Format Parity
- Importable workflow JSON: Yes (`workflow.json` is valid JSON and follows n8n workflow export object shape).
- Required top-level keys: Present (`name`, `nodes`, `connections`).
- Parity references:
  - Official n8n export/import docs: https://docs.n8n.io/workflows/export-import/
  - Community/open workflow source: https://n8n.io/workflows/

## Triggering
- Primary trigger: `Webhook` for inbound call completion events.
- Recommended trigger policy:
  - Use webhook Test URL while developing.
  - Use webhook Production URL only after publishing the workflow.
  - Restrict invokers using webhook IP allowlist where possible.
  - Ensure webhook path+method is unique across all workflows.

## gtm_event_v1 Mapping
- Trigger payload normalizes into:
  - `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`
  - `trace.trace_id` (+ run metadata)
  - `subject.entity_type=call`, `subject.entity_id=<call_id>`
  - `attributes.account_id`, `attributes.opportunity_id`, `attributes.rep_email`
- Terminal outputs remain `gtm_event_v1` envelopes with machine event types.

## Smart-Cog Flow Mapping
1. Signature + trigger validation.
2. Normalize payload to `gtm_event_v1`.
3. `enrich_account_health`.
4. `deal_score_reasoner`.
5. `directive_alignment`.
6. `route_exec_alert`.
7. `approval_loop`.
8. Approved branch creates coaching side effects and emits `coaching.recommendation.created`.
9. Rejected/timeout branch emits `coaching.recommendation.blocked`.

## Retries and Error Handling
- Enable `Retry On Fail` for API-based cog calls and downstream side effects.
- Keep write operations idempotent with `event_id` as key when supported.
- Configure per-workflow Error Workflow (Error Trigger) for failure classification and alerting.
- Use `On Error` behavior intentionally per node (`Stop Workflow` by default; continue modes only when downstream handling is explicit).

## Credentials and Secrets
- Use n8n credentials for Gong, Salesforce, Slack, and internal APIs.
- Prefer predefined credential types when available; use generic HTTP auth only as needed.
- Keep raw auth headers out of exported JSON where possible.
- For multi-env separation, pair n8n environments with external secret vault scopes.

## Queue, Import/Export, and Source Control
- Queue mode is recommended for higher webhook volume and worker scaling.
- Maintain shared `N8N_ENCRYPTION_KEY` for main/worker/webhook processes.
- Import/export workflows through UI or CLI commands.
- Source control in n8n is Git-backed environment sync, not full Git parity:
  - Push and pull in n8n UI.
  - Pull can overwrite local instance changes not yet pushed.
  - Do branch protections and PR reviews in your Git provider.

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
