# n8n Adapter (product-propensity-modeling-machine)

Contract-first n8n adapter for `product-propensity-modeling-machine` using `gtm_event_v1`.

## Artifacts
- `workflow.json`: importable reference workflow for n8n.

## Triggering
- Primary trigger: `Webhook` (`POST`) for event-driven score requests.
- Scheduled trigger option: n8n `Schedule Trigger` set to `0 */6 * * *` (`America/Los_Angeles`).

## gtm_event_v1 Mapping
- Required normalized fields:
  - `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`.
  - `trace.trace_id`, `trace.run_id`.
  - `subject.entity_type`, `subject.entity_id` or `subject.account_id`.
  - `attributes.product_id`, `attributes.scoring_window`.
- Supported trigger event types:
  - `propensity.score_requested`, `propensity.context_ready`, `account.product_signal_changed`.

## Smart-Cog Flow Mapping
1. `Normalize + Validate`.
2. Fetch Endgame context and evidence refs.
3. Merge CRM, warehouse, product telemetry, conversation, market-basket, and optional external signals.
4. `propensity_score_reasoner`.
5. `directive_alignment`.
6. `route_exec_alert`.
7. Build `product.propensity.scored`.
8. Emit terminal event.

## Retries, Errors, and Idempotency
- Enable retry on remote API nodes.
- Deduplicate by `event_id + product_id` before terminal event emission.
- Route validation failures to `product.propensity.failed_validation`.
