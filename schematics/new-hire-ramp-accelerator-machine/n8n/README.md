# n8n Adapter (new-hire-ramp-accelerator-machine)

n8n adapter for provisioning-time onboarding package generation with approval-gated mutations.

## Artifacts
- `workflow.json`: importable reference workflow.

## Triggering
- Realtime trigger: `Webhook` for rep provisioning events.
- Batch trigger: `Schedule Trigger` every 4 hours for reconciliation.

## gtm_event_v1 Contract Mapping
- Input contract: `gtm_event_v1`.
- Required checks: `event_id`, `event_type`, `source`, `occurred_at`, `trace.trace_id`, `subject.entity_id`.
- Output terminal events:
  - `rep.onboarding.package_generated`
  - `rep.onboarding.package_blocked`
  - `rep.onboarding.skipped_duplicate`
  - `rep.onboarding.failed`

## Flow Mapping
1. Normalize + validate.
2. Idempotency lookup.
3. `enrich_account_health`.
4. `directive_alignment`.
5. `compose_outreach_message`.
6. `route_exec_alert`.
7. `approval_loop`.
8. Approved path persists package + emits `rep.onboarding.package_generated`.

## Reliability Notes
- Use idempotency key `event_id`.
- Keep retries idempotent for package-store and CRM writes.
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
