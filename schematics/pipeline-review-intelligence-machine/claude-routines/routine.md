# Routine Spec (pipeline-review-intelligence-machine)

## Metadata
- routine_id: `pipeline_review_intelligence_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: generate manager-ready weekly pipeline intelligence and execute approved follow-up actions.

## Supported Events
- `pipeline.review.requested`
- `deal.updated`
- `activity.logged`

## Stage Plan
1. `validate_input`
- Validate schema + supported event.
- Invalid -> `pipeline.review.prep.failed_validation`.

2. `build_pipeline_context`
- Compute per-opportunity state: `stale_days`, `missing_next_step`, `thread_count`, owner chain.

3. `score_and_summarize`
- Produce risk buckets, manager summary sections, and remediation proposals.

4. `policy_check`
- Validate remediation proposals against directives and allowed action scope.

5. `approval_loop` (conditional)
- Enter when actions include outbound notifications or CRM mutation.
- Non-approved -> `pipeline.review.prep.deferred`.

6. `execute`
- Publish summary and run approved follow-up actions.

7. `emit_result`
- Success: `pipeline.review.prep.completed`.
- Deferred: `pipeline.review.prep.deferred`.
- Failure: `pipeline.review.prep.failed`.

## Practical Permissions
- Keep stage 1-4 read/analysis only.
- Permit write tools only inside `execute` after approval branch.
