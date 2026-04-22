# Routine Spec (new-hire-ramp-accelerator-machine)

## Metadata
- routine_id: `new_hire_ramp_accelerator_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: generate onboarding package artifacts and execute approved downstream actions.

## Supported Events
- `rep.onboarding.requested`
- `rep.start_date_confirmed`
- `territory.assignment.updated`

## Stage Plan
1. `validate_input`
- Validate contract and event support.
- Invalid -> `rep.onboarding.failed_validation`.

2. `build_context`
- Pull rep profile, territory/book composition, and directive context.

3. `assemble_package`
- Build `territory_snapshot`, `starter_accounts`, `messaging_kit`, `week_one_plan`.

4. `policy_check`
- Validate content against directive set and role permissions.

5. `approval_loop`
- Required before doc publish, CRM task creation, or outbound manager notifications.
- Non-approved -> `rep.onboarding.package_blocked`.

6. `execute_actions`
- Apply approved side effects with `event_id` idempotency.

7. `emit_result`
- Success: `rep.onboarding.package_generated`.
- Blocked: `rep.onboarding.package_blocked`.
- Failure: `rep.onboarding.failed`.

## Subagent Pattern
- Optional read-only `ramp-researcher` for territory/account discovery.
- Main routine owns approvals and all write actions.
