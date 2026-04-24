# Agentic Runbook (product-propensity-modeling-machine)

## Runtime Contract
- Orchestration shape: **planner -> executor -> evaluator** with checkpoint persistence.
- Input schema: `gtm_event_v1`
- Output schema: `gtm_event_v1`
- Idempotency key: `event_id + attributes.product_id`.

## Canonical Ingest Contract (`gtm_event_v1`)
Required keys at stage entry:
- `schema_version`, `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`
- `trace.trace_id`
- `subject.entity_type`, `subject.entity_id` or `subject.account_id`
- `attributes.product_id`, `attributes.scoring_window`

## Stage 1: Planner (Validate, Dedupe, Plan)
1. Validate contract and allowed `event_type` values.
2. Dedupe by `event_id + product_id`; if terminal, return prior outcome metadata.
3. Build execution plan:
   - Endgame context fetch tools
   - CRM, warehouse, usage, conversation, and optional external-signal tools
   - `propensity_score_reasoner`
   - directive checks
   - proposed side effects
4. Assign score path (`read_only|writeback_candidate|review_required`) and approval requirements.

## Stage 2: Executor (Tools + Cogs)
1. Read Endgame context through MCP/CLI adapters and capture evidence refs.
2. Merge CRM fit, product usage, market-basket, historical conversion, conversation, and external timing signals.
3. Execute `propensity_score_reasoner` and preserve model/cog version in output attributes.
4. Run `directive_alignment` on seller-facing reason text and recommended play.
5. Generate normalized candidate output (`draft_event`) and `proposed_actions[]`.
6. Persist per-tool latency, retries, feature snapshot ID, and evidence references.

## Stage 3: Evaluator (Guardrails + HITL + Emit)
1. Validate required score fields and evidence completeness.
2. Block unsupported tools or unscoped account/product access.
3. Remove raw sensitive feature values from seller-facing explanations.
4. Approval-gate CRM writeback, audience sync, seller alert, and outbound actions when configured.
5. Execute approved side effects idempotently.
6. Emit final `gtm_event_v1` terminal event.

## HITL Gate for CRM Writes and Alerts
- Read-only scoring can auto-run.
- CRM writeback, seller alerts, campaign/audience sync, and outbound sends require approve/reject/edit when `crm_writeback_requires_approval` is enabled.
- On deny or timeout, emit blocked/deferred terminal event without mutations.

## Terminal Events
- `product.propensity.scored`
- `product.propensity.blocked`
- `product.propensity.failed_validation`
- `product.propensity.failed`
