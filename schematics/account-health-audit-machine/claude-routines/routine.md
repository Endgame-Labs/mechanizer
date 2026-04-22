# Routine Spec (account-health-audit-machine)

## Metadata
- routine_id: `account_health_audit_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: produce deterministic account-health narrative + prioritized roadmap, with approval-gated side effects.

## Trigger Contract
- Supported `event_type`:
  - `audit.run_requested`
  - `audit.snapshot_ready`
- Routine entry assumptions:
  - Scheduled runs may have empty API `text`.
  - API-triggered runs may include freeform `text`; do not assume JSON.

## Tool Permission Profile (Logical)
- Read tools: always allowed (`endgame_mcp`, warehouse, CRM read, conversation read).
- Mutation tools: callable only in `approval_loop == approved` branch:
  - `crm_task_upsert`, `slack_notify`, `email_send`, `doc_upsert`.

## Stage Plan
1. `validate_input`
- Validate envelope and required fields.
- If invalid emit `account.health.audit.failed_validation`.

2. `build_context`
- Fetch warehouse, CRM, and conversation snapshots.
- Normalize to `attributes.enrichment.*`.

3. `run_scoring`
- Compute risk/opportunity via deterministic scoring map.
- Produce `risk_band`, `health_score`, `reason_codes[]`.

4. `compose_narrative`
- Generate summary and ordered roadmap from score bands + reason codes.
- Attach supporting evidence refs.

5. `approval_loop` (conditional)
- Enter only if planned actions include outbound comms or CRM/doc mutation.
- Decisions:
  - `approved`: continue.
  - `rejected|expired|needs_info`: emit `account.health.audit.blocked`.

6. `execute_actions`
- Run only approved side effects.
- Persist idempotency key as `event_id` on external writes.

7. `emit_result`
- Success: `account.health.audit.completed`.
- Blocked: `account.health.audit.blocked`.
- Failure: `account.health.audit.failed`.

## Subagent Pattern
- Optional `research-summarizer` subagent for long timeline condensation.
- Restrict to read-only tools (`Read`, `Grep`, relevant MCP read tools).
- Subagents return structured findings; main routine owns decisions and writes.

## Failure + Retry
- Retry transient tool failures up to 3 times with exponential backoff.
- No retries for validation/policy/approval denial branches.
- Always emit terminal event with `error_stage` when failed.
