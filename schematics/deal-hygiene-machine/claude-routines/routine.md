# Routine Spec (deal-hygiene-machine)

## Metadata
- routine_id: `deal_hygiene_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: detect hygiene drift, recommend remediations, execute approved writebacks.

## Supported Events
- `deal.updated`
- `call.completed`
- `account.health_changed`

## Stage Plan
1. `validate_input`
- Validate contract + supported event.
- Invalid -> `deal.hygiene.failed_validation`.

2. `gather_context`
- Pull CRM record state + recent account timeline context.

3. `score_and_reason`
- Produce `hygiene_score`, `score_band`, `reason_codes[]`, `recommended_play`.

4. `policy_check`
- Validate proposed field changes against directive/policy controls.

5. `approval_loop`
- Required for `sfdc_writeback` actions.
- `approved` -> proceed.
- `rejected|expired|needs_info` -> `deal.hygiene.deferred`.

6. `execute_writeback`
- Apply approved field updates only.
- Include `event_id` idempotency marker.

7. `emit_result`
- Success: `deal.hygiene.remediated`.
- Deferred: `deal.hygiene.deferred`.
- Failure: `deal.hygiene.writeback_failed`.

## Subagent Pattern
- Optional read-only `timeline-summarizer` subagent for large account histories.
- Main routine retains all mutation and approval stages.

## Retry Policy
- Transient tool failures: retry x3 with exponential backoff.
- No retries for validation/policy/approval denial.
