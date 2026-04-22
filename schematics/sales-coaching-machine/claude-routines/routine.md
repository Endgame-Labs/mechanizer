# Routine Spec (sales-coaching-machine)

## Metadata
- routine_id: `sales_coaching_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: generate evidence-backed coaching recommendations and execute approved follow-through actions.

## Supported Events
- `call.completed`
- `deal.stage_changed`
- `rep.activity_low`

## Stage Plan
1. `validate_input`
- Validate schema and required identifiers.
- Invalid -> `coaching.recommendation.failed_validation`.

2. `collect_context`
- Pull call transcript signals + CRM opportunity context.

3. `draft_recommendation`
- Generate primary and fallback recommendation.
- Include citation refs.

4. `alignment_check`
- Enforce directive/rubric compatibility and evidence threshold.

5. `approval_loop`
- Required before `create_salesforce_task` and outbound manager notifications.
- Non-approval -> `coaching.recommendation.blocked`.

6. `execute`
- Create CRM task and/or review notification on approved branch.

7. `emit`
- Success: `coaching.recommendation.created`.
- Blocked: `coaching.recommendation.blocked`.
- Failure: `coaching.recommendation.failed`.

## Subagent Pattern
- Optional read-only `transcript-analyzer` for heavy extraction.
- Keep mutation calls in main routine only.

## Quality Gates
- At least one transcript citation required.
- Stale context (>24h) forces approval path.
