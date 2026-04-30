# Routine Spec (long-tail-account-coverage-machine)

## Metadata
- routine_id: `longtail_account_coverage_v1`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: continuously monitor long-tail accounts and execute approved churn/expansion plays.

## Supported Events
- `account.health_changed`
- `usage.declined`
- `renewal.window_opened`
- `intent.signal_detected`

## Stage Plan
1. `validate_input`
- Validate envelope and supported event types.
- Invalid -> `longtail.coverage.failed_validation`.

2. `enrich_context`
- Pull account timeline, CRM state, and telemetry features.

3. `score_and_select_play`
- Produce churn/expansion score + recommended play.

4. `policy_check`
- Run directive alignment and action-scope checks.

5. `compose_actions`
- Build outreach draft and CRM mutation proposal.

6. `approval_loop`
- Required before `outbound_send` or `crm_update`.
- Non-approved -> `longtail.coverage.blocked`.

7. `execute`
- Apply approved actions with idempotency key `event_id`.

8. `emit`
- Success: `longtail.coverage.executed`.
- Blocked: `longtail.coverage.blocked`.
- Failure: `longtail.coverage.failed`.

## Subagent Guidance
- Optional read-only `cohort-researcher` for large cohort triage.
- Main routine retains approval + mutation responsibilities.
