# Zapier Adapter (deal-hygiene-machine)

## Reference Artifact
- `zap.template.json`: template metadata and step contract for a multi-step Zap.

## Trigger Mapping
- Trigger app/event: `Webhooks by Zapier -> Catch Hook` (or `Salesforce -> Updated Record`).
- Normalize trigger payload to `gtm_event_v1` in `Code by Zapier`:
  - Require `schema_version`, `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`, `trace`, `subject`, `attributes`.
  - Preserve all non-canonical provider data under `raw`.

## Transform and Cog Steps
1. `Normalize Event` (Code step) validates schema and default fields.
2. `enrich_account_health` (Webhook/custom action) merges telemetry and CRM context.
3. `deal_score_reasoner` computes risk score and remediation suggestion.
4. `directive_alignment` evaluates policy blocks and required approvers.
5. `route_exec_alert` builds owner + escalation destinations.
6. `approval_loop` requests human/system approval before any mutation.
7. Approved path executes SFDC/task actions and emits output event.

## Approval Loop Placement
- Place an approval gate immediately before every mutation action.
- Condition: `approval.status == "approved"`.
- Non-approved branch sends alert/note only; no SFDC updates.

## Zapier Runtime Capabilities and Limits (verified 2026-04-22)
- Paths:
  - Up to 10 path branches per path group.
  - Up to 3 nested Paths steps per Zap.
  - Paths execute sequentially (left to right).
  - Paths must be the final step; no shared post-path action block.
- Filters:
  - If filter conditions fail, no subsequent actions run.
  - Filter/Paths steps do not consume task usage.
  - With line items, negative conditions require all items to pass.
- Code by Zapier:
  - JavaScript runs on Node.js 22; code is sandboxed.
  - I/O cap is 6 MB for code plus processed data.
  - Runtime/rate limits are plan-based (for example, Pro/Team: 30s runtime, 225 executions per 10s).
- Webhooks by Zapier:
  - Catch Raw Hook payload limit: 2 MB (includes headers).
  - Max webhook payload size: 10 MB for triggers, 5 MB for webhook actions.
  - Rate limits: 20,000 requests per 5 minutes per user; legacy routes 1,000 requests per 5 minutes per Zap.
- Retries and replay:
  - Autoreplay retries failed errored steps up to 5 times (5m, 30m, 1h, 3h, 6h cadence).
  - Filter and Paths steps are never replayed.
  - Replays must occur within 60 days and require the Zap to be on.
- Templates and guided templates:
  - Shared Zap templates include step structure but no entered field values.
  - Zaps with Code steps/private apps/legacy apps cannot be shared as classic copy templates.
  - Guided templates can lock or expose configured fields/variables and provide setup wizard instructions.
- Import/export scope:
  - Import/export is Team/Enterprise only.
  - JSON format only.
  - Non-admin users can export only their own Zaps.
  - Account owner/super admin can export all users' Zaps.

## Reliability and Idempotency
- Use `Storage by Zapier` with key `deal-hygiene:${event_id}`.
- If key exists with terminal status, stop Zap and emit duplicate metric.
- Store terminal result (`remediated`, `deferred`, `failed_validation`, `writeback_failed`).
- For webhook emits, retry with exponential backoff when Zapier returns non-200 or webhook transport errors.
