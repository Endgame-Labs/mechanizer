# Zapier Adapter (product-propensity-modeling-machine)

Zapier implementation for recurring or webhook-triggered account-product propensity scoring.

## Artifact
- `zap.template.json`

## Recommended Zap Shape
1. Trigger from `Schedule by Zapier` every six hours or `Webhooks by Zapier` on a score request.
2. Normalize payload to `gtm_event_v1` in `Code by Zapier`.
3. Deduplicate with `Storage by Zapier` key `product-propensity:${event_id}:${product_id}`.
4. Pull Endgame, CRM, warehouse, product usage, conversation, and optional external context via webhook action.
5. Run `propensity_score_reasoner` and `directive_alignment`.
6. Route high-confidence high scores to seller alert paths when approved.
7. Emit `product.propensity.scored`.
8. Persist terminal status in `Storage by Zapier`.

## Practical Zapier Notes
- Prefer `Catch Hook` for parsed JSON.
- Keep branching in a final `Paths` step.
- Keep all external write calls idempotent with `event_id + product_id`.
- Treat CRM writeback, audience sync, and outbound send actions as approval-gated.
