# Routine Spec (nrr-machine)

## Metadata
- routine_id: `nrr_machine_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: select NRR play for low/no-touch accounts and execute approved actions.

## Supported Events
- `account.health_changed`
- `usage.declined`
- `renewal.window_opened`

## Stage Plan
1. `validate_input`
- Validate schema + event support.
- Invalid -> `nrr.play.failed_validation`.

2. `enrich_context`
- Build normalized feature map from usage, billing, CRM, and account timeline.

3. `segment_gate`
- Continue only for `low_touch|no_touch` segments.
- Out-of-scope -> `nrr.play.blocked`.

4. `score_and_select_play`
- Compute risk/expansion scores.
- Pick `critical_retention|expansion_push|monitor_and_nudge`.

5. `policy_check`
- Directive and action-scope validation.

6. `approval_loop`
- Required before outbound or CRM write operations.
- Non-approved outcomes -> `nrr.play.blocked`.

7. `execute_actions`
- Execute approved outbound + CRM changes with idempotency key `event_id`.

8. `emit_result`
- Success: `nrr.play.executed`.
- Blocked: `nrr.play.blocked`.
- Failure: `nrr.play.failed`.

## Subagent Guidance
- Optional read-only subagents for high-volume context ingestion.
- Main routine keeps control of policy, approval, and mutation stages.

## Retry Semantics
- Transient connector/tool failures: retry x3.
- Validation/policy/approval failures: no retry.
