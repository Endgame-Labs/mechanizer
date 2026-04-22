# Routine Spec (consumption-renewal-intervention-machine)

## Metadata
- routine_id: `consumption_renewal_intervention_v1`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: identify renewal consumption risk and execute approved intervention actions.

## Supported Events
- `renewal.window_opened`
- `renewal.consumption_under_target_detected`

## Stage Plan
1. `validate_input`
- Contract and event validation.
- Invalid -> `cri.play.failed_validation`.

2. `collect_signals`
- Pull consumption, contract, renewal, support, and engagement features.

3. `score_intervention`
- Compute intervention score and play recommendation (`rescue`, `expand`, `monitor`).

4. `compose_plan`
- Build intervention package with owners, deadlines, and evidence refs.

5. `notify`
- Send non-mutating Slack summary (if enabled).

6. `approval_loop`
- Required for optional actions:
  - `renewal_plan_update`
  - `csm_task_create`
  - `email_send`

7. `execute_optional_actions`
- Execute only on `approved` decision.

8. `emit_result`
- Success: `cri.play.executed`.
- Partial/blocked: `cri.play.blocked_optional_actions`.
- Failure: `cri.play.failed`.

## Permissions + Safety
- Stage 1-5: read + notify scope.
- Stage 7: write scope unlocked only on approved branch.
- Use `event_id` as idempotency key for all external mutations.
