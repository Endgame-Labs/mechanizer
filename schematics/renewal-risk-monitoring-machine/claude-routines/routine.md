# Routine Spec (renewal-risk-monitoring-machine)

## Metadata
- routine_id: `renewal_risk_monitoring_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: monitor renewal risk daily, notify owners, and execute approved interventions.

## Supported Events
- `renewal.window_opened`
- `account.risk_signal.detected`

## Stage Plan
1. `validate_input`
- Validate schema and supported events.
- Invalid -> `renewal.risk.failed_validation`.

2. `enrich_context`
- Gather usage, billing, CRM, and timeline context.

3. `score_risk_and_select_play`
- Generate risk score, severity, and recommended play.

4. `build_recommendation`
- Produce rationale + next actions + evidence refs.

5. `notify_csm_slack`
- Always send owner notification summary.

6. `route_exec_alert_if_high_severity`
- Escalate high-severity cases.

7. `approval_loop_optional_actions`
- Required for optional actions (`crm_update`, `email_send`, `task_create`).

8. `execute_approved_actions`
- Apply only approved optional actions with idempotency keys.

9. `emit_result`
- Success: `renewal.risk.play.executed`.
- Partial/blocked: `renewal.risk.play.blocked`.
- Failure: `renewal.risk.play.failed`.
