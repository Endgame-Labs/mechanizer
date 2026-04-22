# Routine Spec (account-plan-generation-machine)

## Metadata
- routine_id: `account_plan_generation_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: generate structured account plans and execute approved persistence actions.

## Supported Inputs
- `account.plan.refresh_requested`
- `account.tier_changed`
- `planning.window_opened`

## Stage Plan
1. `validate_input`
- Validate schema and required `subject`/`trace` fields.
- Unsupported/invalid input -> `account.plan.failed_validation`.

2. `gather_context`
- Pull CRM state, account activity, relationship graph, and prior plan delta.

3. `build_plan`
- Produce sections:
  - `context`
  - `relationship_map`
  - `whitespace`
  - `plays`
- Record evidence refs and confidence.

4. `policy_check`
- Run directive alignment checks.
- Fail closed when directives conflict with generated recommendations.

5. `approval_loop`
- Required for `plan_doc_upsert` and `crm_plan_fields_update`.
- Decision handling:
  - `approved` -> continue
  - `rejected|expired|needs_info` -> `account.plan.blocked`

6. `execute`
- Persist approved changes with idempotency key `event_id`.

7. `emit`
- Success: `account.plan.generated`.
- Blocked: `account.plan.blocked`.
- Failure: `account.plan.failed`.

## MCP / External Wiring
- Typical server map:
  - `mcp__endgame__*` for context.
  - `mcp__salesforce360__*` for CRM read/write.
  - `mcp__docs__*` for plan documents.
- Keep write-capable tools out of early stages; call only from `execute`.

## Subagent Guidance
- Optional `relationship-mapper` or `telemetry-summarizer` subagents.
- Use read-only tool lists and bounded `maxTurns`.
