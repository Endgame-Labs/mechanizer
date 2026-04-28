# Workato Adapter (account-plan-generation-machine)

Workato implementation notes for `account-plan-generation-machine` using API recipes, recipe functions for shared smart cogs, lookup-table idempotency, and Workato job history for replay/debugging.

## Artifact
- `recipe.json`: Workato recipe reference scaffold for build guidance and lifecycle packaging.

## Recipe Shape
1. Receive `gtm_event_v1` through an API Platform recipe endpoint for `account-plan-generation-machine`.
2. Add a companion scheduled recipe for `0 */6 * * *` in `workspace default` that calls the same recipe-function path for periodic sweeps.
3. Validate and normalize the canonical event envelope.
4. Check a lookup-table idempotency key before side effects.
5. Call shared recipe functions for smart cogs: `enrich_account_health`, `deal_score_reasoner`, `directive_alignment`, `compose_outreach_message`, `route_exec_alert`, `approval_loop`.
6. Run `approval_loop` before mutating downstream systems or sending external actions.
7. Branch approved/deferred, perform allowed side effects, emit terminal `gtm_event_v1`, and write run summary.

## Terminal Events
- Approved path emits `account.plan.generated` from `emit_terminal_event.body.event_type`.
- Blocked/deferred path emits `account.plan.blocked` from `emit_terminal_event.body.event_type`.
## Idempotency and State
- Use a lookup table key `account-plan-generation-machine:{event_id}` before any downstream side effect.
- Persist terminal status, approval decision when present, `trace.trace_id`, and Workato job URL.
- Keep secrets in Workato connections or project/environment properties, not lookup-table rows.

## Error Handling
- Wrap cog calls and downstream connector actions in Workato error monitor/handle-error blocks.
- Route unrecoverable failures to the shared dead-letter publisher with `machine_id`, `event_id`, `trace_id`, failed step, error type, and job URL.
- Use job reruns for replay after mapping fixes; reruns should preserve `event_id` dedupe behavior.

## SDLC / Promotion
1. Build in a dev project with non-production connections.
2. Package with Recipe lifecycle management.
3. Import into the target workspace and remap connections, properties, lookup tables, and API endpoints.
4. Validate recipe functions and event topics before enabling triggers.
5. Start recipes according to release policy.

## Format Parity
- Compatibility posture: `recipe.json` tracks machine intent and step sequencing, but it is not a native Workato lifecycle package export.
- Importability: reference scaffold, not fully importable as-is. Use Workato Recipe lifecycle management for deployable packages.
- New builds should use API recipes and Recipe functions instead of deprecated callable recipes.

## References
- https://docs.workato.com/recipe-development-lifecycle.html
- https://docs.workato.com/workato-api/recipe-lifecycle-management.html
- https://docs.workato.com/features/callable-recipes/migrating-to-recipe-functions-api-recipes.html
- https://docs.workato.com/recipes/jobs
- https://docs.workato.com/recipes/best-practices-error-handling
