# n8n Adapter (account-health-audit-machine)

![Account Health Audit Machine Diagram](../diagram.svg)

Contract-first n8n adapter for `account-health-audit-machine` using `gtm_event_v1` as the canonical envelope.

## Artifacts
- `workflow.json`: importable reference workflow for n8n.

## Format Parity
- Importable workflow JSON: Yes (`workflow.json` is valid JSON and follows n8n workflow export object shape).
- Required top-level keys: Present (`name`, `nodes`, `connections`).
- Parity references:
  - Official n8n export/import docs: https://docs.n8n.io/workflows/export-import/
  - Community/open workflow source: https://n8n.io/workflows/

## Triggering
- Primary trigger: `Webhook` (`POST`) for event-driven ingestion.
- Scheduled trigger option: n8n `Schedule Trigger` set to `0 6 * * 1-5` (`America/Los_Angeles`).

## gtm_event_v1 Mapping
- Required normalized fields:
  - `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`.
  - `trace.trace_id`, `trace.run_id`.
  - `subject.entity_type`, `subject.entity_id`.
- Supported trigger event types:
  - `audit.run_requested`, `audit.snapshot_ready`.

## Smart-Cog Flow Mapping
1. `Normalize + Validate`.
2. Warehouse/CRM/conversation context merge.
3. `enrich_account_health`.
4. `deal_score_reasoner`.
5. `directive_alignment`.
6. `route_exec_alert`.
7. Deterministic narrative + roadmap generation.
8. Emit `account.health.audit.completed`.

## Retries, Errors, and Idempotency
- Enable retry on remote API nodes (3 tries with increasing waits).
- Deduplicate by `event_id` before terminal event emission.
- Route hard validation failures to `account.health.audit.failed_validation`.

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
