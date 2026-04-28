# Claw-Like Runner (product-propensity-modeling-machine)

![Product Propensity Modeling Machine Diagram](../diagram.svg)

Run scheduled product propensity scoring and liveness monitoring from `HEARTBEAT.md`.

## Execution Loop
1. Read heartbeat schedule and acquire advisory/lease lock.
2. Generate or accept account-product score request events.
3. Validate `gtm_event_v1` and dedupe by `event_id + product_id`.
4. Fetch Endgame context and feature sources.
5. Run `propensity_score_reasoner`, `directive_alignment`, `route_exec_alert`, and conditional `approval_loop`.
6. Emit `product.propensity.scored` or a blocked/failed terminal event.
7. Write heartbeat success/failure metadata.

## Cadence
- Schedule: `0 */6 * * *` (`America/Los_Angeles`)
- Cadence note: six-hour refresh for priority account-product pairs, with event-triggered reruns for signal changes.

## Safe Mode
- Continue read-only scoring where possible.
- Block CRM writes, seller alerts, audience syncs, outbound sends, and irreversible actions.
