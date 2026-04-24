# Routine Spec (product-propensity-modeling-machine)

## Metadata
- routine_id: `product_propensity_modeling_v1`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: produce evidence-backed account-product propensity scores, confidence, reason codes, and approval-gated side effects.

## Trigger Contract
- Supported `event_type`:
  - `propensity.score_requested`
  - `propensity.context_ready`
  - `account.product_signal_changed`

## Tool Permission Profile (Logical)
- Read tools: always allowed (`endgame_mcp`, `endgame_cli`, warehouse, CRM read, product telemetry, conversation read, optional web research).
- Mutation tools: callable only in `approval_loop == approved` branch:
  - `crm_propensity_field_upsert`, `seller_alert_send`, `audience_sync`, `task_create`.

## Stage Plan
1. `validate_input`
- Validate envelope, account identity, product ID, trace, and scoring window.
- If invalid emit `product.propensity.failed_validation`.

2. `build_context`
- Fetch Endgame account graph, documents, notes, interactions, and directive refs.
- Normalize CRM, warehouse, usage, market-basket, conversation, and external signals to `attributes.enrichment.*`.

3. `run_propensity_score`
- Compute account-product score using deterministic features plus agentic evidence reasoning.
- Produce `propensity_score`, `propensity_band`, `score_confidence`, `reason_codes[]`, `recommended_play`, and `evidence_refs[]`.

4. `directive_alignment`
- Validate seller-facing explanations and recommended play against approved messaging/directives.
- Remove or block claims not supported by evidence refs.

5. `approval_loop` (conditional)
- Enter only if planned actions include CRM writes, seller alerts, audience syncs, or outbound comms.
- Decisions:
  - `approved`: continue.
  - `rejected|expired|needs_info`: emit `product.propensity.blocked`.

6. `execute_actions`
- Run only approved side effects.
- Persist idempotency key as `event_id + product_id` on external writes.

7. `emit_result`
- Success: `product.propensity.scored`.
- Blocked: `product.propensity.blocked`.
- Failure: `product.propensity.failed`.
