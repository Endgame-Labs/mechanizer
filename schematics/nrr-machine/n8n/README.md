# n8n Adapter (nrr-machine)

n8n adapter for `nrr-machine` focused on low-touch/no-touch execution with approval-gated side effects.

## Artifacts
- `workflow.json`: importable reference workflow.

## Triggering
- Realtime trigger: `Webhook` for `account.health_changed`, `usage.declined`, `renewal.window_opened`.
- Batch trigger: `Schedule Trigger` every 6 hours to generate synthetic refresh events.
- Trigger best practices:
  - Use webhook Test URL for development and Production URL after publish.
  - Schedule trigger requires correct timezone and a published workflow.
  - Keep webhook path+method unique instance-wide.

## gtm_event_v1 Contract Mapping
- Input contract: `gtm_event_v1`.
- Required checks: `event_id`, `event_type`, `source`, `occurred_at`, `trace.trace_id`, `subject.entity_id`.
- Output terminal events:
  - `nrr.play.executed`
  - `nrr.play.blocked`
  - `nrr.play.skipped_duplicate`
  - `nrr.play.failed`

## Smart-Cog Flow Mapping
1. `Normalize + Validate`.
2. `enrich_account_health` (context aggregation).
3. Segment gate (`low_touch`, `no_touch`).
4. `deal_score_reasoner` (score + play classification).
5. `directive_alignment`.
6. `compose_outreach_message`.
7. `route_exec_alert`.
8. `approval_loop`.
9. Approved branch runs outbound + CRM side effects and emits `nrr.play.executed`.

## Retries and Error Workflows
- Use node `Retry On Fail` for network/API nodes.
- Suggested defaults:
  - Context + scoring calls: 3 tries (`5s`, `15s`, `45s`).
  - Approval + side-effect calls: 2 tries with idempotency keys.
- Configure a reusable Error Trigger workflow in Workflow Settings for operational alerts and failed-event emission.
- Error workflow behavior is for automatic executions; manual runs do not trigger Error Trigger.

## Queue Mode and Throughput
- For sustained volume, run queue mode (`EXECUTIONS_MODE=queue`) with Redis + workers.
- Main process handles trigger/webhook intake, workers execute jobs.
- Keep `N8N_ENCRYPTION_KEY` shared across main, workers, and webhook processors.
- Prefer Postgres in queue mode and tune worker concurrency carefully.

## Credentials and Security
- Keep API tokens in n8n credentials, not inline node parameters.
- Exported workflow JSON includes credential names/IDs; sanitize before sharing.
- For environment-specific secrets in Git-backed environments, use external secrets vaults per environment/project.

## Import / Export / Source Control Notes
- Import/export supported via UI and CLI (`n8n export:workflow`, `n8n import:workflow`, and credential counterparts).
- n8n source control is Git-backed environments, but not full Git parity:
  - Push/pull from n8n UI.
  - Pull can overwrite local unpushed changes.
  - Keep PR review and branch protection in your Git provider.
