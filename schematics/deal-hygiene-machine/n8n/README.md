# n8n Adapter (deal-hygiene-machine)

Contract-first n8n adapter for `deal-hygiene-machine` using `gtm_event_v1` as the canonical envelope.

## Artifacts
- `workflow.json`: importable reference workflow for n8n.

## Triggering
- Primary trigger: `Webhook` (`POST`) for event-driven ingestion.
- Recommended production setup:
  - Build/test with the webhook **Test URL**.
  - Publish and use the webhook **Production URL** for live traffic.
  - Keep webhook `path + method` unique across the n8n instance.
- Optional alternative trigger for direct CRM eventing: Salesforce Trigger.

## gtm_event_v1 Mapping
- Required normalized fields:
  - `event_id`: immutable dedupe key.
  - `event_type`: one of `deal.updated`, `call.completed`, `account.health_changed`.
  - `source`, `occurred_at`, `ingested_at`.
  - `trace.trace_id` and per-run `trace.run_id`.
  - `subject.entity_type`, `subject.entity_id`.
- Adapter emits terminal events in the same contract envelope.

## Smart-Cog Flow Mapping
1. `Normalize + Validate` (Code node): enforce canonical fields and defaults.
2. `enrich_account_health`.
3. `deal_score_reasoner`.
4. `directive_alignment`.
5. `route_exec_alert`.
6. `approval_loop` (mandatory gate before side effects).
7. Approved branch executes writeback and emits `deal.hygiene.remediated`.
8. Non-approved/duplicate branch emits `deal.hygiene.deferred`.

## Retries, Errors, and Idempotency
- Node-level retry policy:
  - Enable `Retry On Fail` on remote API calls.
  - Use 3 tries with backoff-like waits (for example `5s`, `15s`, `45s`) for transient failures.
- Error workflow:
  - Configure a dedicated error workflow that starts with **Error Trigger**.
  - Error Trigger runs for automatic executions, not manual test runs.
- Idempotency:
  - Pre-check terminal state using `event_id` and `event_type`.
  - Skip writes when already completed/deferred/failed terminally.

## Queue Mode and Scale Notes
- For higher throughput, run in queue mode with workers + Redis.
- Keep `N8N_ENCRYPTION_KEY` identical on main, workers, and webhook processors.
- Use Postgres for queue mode; avoid SQLite for distributed execution.
- Tune worker concurrency conservatively to avoid DB pool exhaustion.

## Credentials and Secrets
- Store credentials in n8n credentials store; avoid static secrets in node JSON.
- If using source control or exporting JSON, scrub sensitive credential names/headers before sharing.
- For multi-environment secret isolation, use external secrets vaults and project-scoped vaults where applicable.

## Import / Export / Source Control
- Import/export options:
  - Editor UI (`Download`, `Import from File`, `Import from URL`).
  - CLI (`n8n export:workflow`, `n8n import:workflow`, plus credential export/import commands).
- n8n source control notes:
  - Git integration is environment-focused and not a full PR workflow.
  - Pull can overwrite local unpublished/unpushed changes.
  - Keep review/merge controls in your external Git provider.

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
