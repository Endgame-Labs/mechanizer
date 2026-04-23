# n8n Adapter (account-plan-generation-machine)

n8n adapter for recurring and bulk account-plan generation with approval-gated mutations.

## Artifacts
- `workflow.json`: importable reference workflow.

## Format Parity
- Importable workflow JSON: Yes (`workflow.json` is valid JSON and follows n8n workflow export object shape).
- Required top-level keys: Present (`name`, `nodes`, `connections`).
- Parity references:
  - Official n8n export/import docs: https://docs.n8n.io/workflows/export-import/
  - Community/open workflow source: https://n8n.io/workflows/

## Triggering
- Realtime trigger: `Webhook` for planning events.
- Batch trigger: `Schedule Trigger` every 6 hours for cohort refresh.

## gtm_event_v1 Contract Mapping
- Input contract: `gtm_event_v1`.
- Required checks: `event_id`, `event_type`, `source`, `occurred_at`, `trace.trace_id`, `subject.entity_id`.
- Output terminal events:
  - `account.plan.generated`
  - `account.plan.blocked`
  - `account.plan.skipped_duplicate`
  - `account.plan.failed`

## Flow Mapping
1. Normalize + validate.
2. Idempotency lookup.
3. `enrich_account_health`.
4. `deal_score_reasoner`.
5. `directive_alignment`.
6. `compose_outreach_message`.
7. `route_exec_alert`.
8. `approval_loop`.
9. `Approved?` gate controls all mutation paths.
10. Approved path updates Salesforce, sends owner brief, and emits `account.plan.generated`.
11. Non-approved path emits `account.plan.blocked`.

## Reliability Notes
- Use idempotency key `event_id`.
- Keep retries idempotent for plan-store and CRM writes.
- Route terminal failures into an error workflow.

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
