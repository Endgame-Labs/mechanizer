# Routine Spec (stage-change-deal-review-machine)

## Metadata
- routine_id: `stage_change_deal_review_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: validate stage-change quality and apply only approved CRM remediations.

## Supported Events
- `deal.stage_changed`
- `opportunity.stage_changed`

## Stage Plan
1. `validate_input`
- Validate envelope and event support.
- Invalid -> `deal.stage_review.failed_validation`.

2. `gather_context`
- Pull stage progression history, qualification artifacts, and directive policy set.

3. `analyze_stage_change`
- Produce:
  - `qualification_confidence`
  - `risk_band`
  - `missing_fields`
  - `proposed_mutations`

4. `approval_loop`
- Submit `proposed_mutations`.
- `approved` -> writeback path.
- `rejected|needs_info|expired` -> findings-only path.

5. `execute`
- Approved: apply CRM mutation and emit `deal.stage_review.writeback_applied`.
- Not approved: publish findings and emit `deal.stage_review.findings_posted`.

## Reliability
- Idempotency key: `event_id`.
- Retry transient failures up to 3 attempts.
- Validation/policy/approval-denied branches are terminal.
