# Make Adapter (product-propensity-modeling-machine)

Make scenario reference for scheduled and webhook-triggered product propensity scoring.

## Artifact
- `scenario.json`: blueprint-style reference for account-product score refreshes.

## Scenario Shape
1. Trigger on six-hour schedule or webhook score request.
2. Normalize `gtm_event_v1` and require account identity plus `attributes.product_id`.
3. Deduplicate by `event_id + product_id`.
4. Fetch Endgame propensity context and evidence refs.
5. Run `propensity_score_reasoner`.
6. Run directive alignment and aggregate evidence refs.
7. Emit `product.propensity.scored`.
8. Persist run summary for auditability.
