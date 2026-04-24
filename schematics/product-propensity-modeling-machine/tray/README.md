# Tray Adapter (product-propensity-modeling-machine)

Tray runtime for `product-propensity-modeling-machine` with scheduled and callable execution modes, reusable propensity smart cogs, and approval-gated write actions.

## Artifact
- `workflow.json`

## Workflow Shape
1. Scheduled trigger runs six-hour score refreshes; callable trigger handles on-demand score requests.
2. Validate `gtm_event_v1`, account identity, product ID, and trace.
3. Deduplicate by `event_id + product_id`.
4. Fetch Endgame/CRM/warehouse/product/conversation/external context.
5. Run `propensity_score_reasoner`.
6. Run `directive_alignment`.
7. Approval-gate CRM writeback, audience sync, seller alert, and outbound side effects.
8. Emit `product.propensity.scored`.
