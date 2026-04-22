# Routine Spec (nrr-machine)

## Routine Metadata
- routine_id: `nrr_machine_v1`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: select and execute NRR intervention for low-touch/no-touch accounts

## Claude Runtime Assumptions (Apr 22, 2026)
- Executes as a Claude Code routine cloud session.
- Routine sessions are autonomous and do not present in-run permission prompts.
- Any required human/business sign-off must be implemented by machine logic (`approval_loop`), not Claude permission modes.
- API-triggered runs accept optional freeform `text`; structured payloads are treated as plain text.

## Stage Plan
1. `validate_input`
- Verify required `gtm_event_v1` fields.
- Verify supported `event_type` in `account.health_changed|usage.declined|renewal.window_opened`.
- Reject malformed payloads with `nrr.play.failed`.

2. `enrich_context`
- Pull account context from Endgame and Salesforce Headless 360.
- Pull usage/billing signals.
- Build normalized feature map.

3. `segment_gate`
- Continue only if `segment` is `low_touch` or `no_touch`.
- Otherwise emit `nrr.play.blocked` (`segment_out_of_scope`).

4. `score_and_select_play`
- Compute risk and expansion scores.
- Select one of: `critical_retention`, `expansion_push`, `monitor_and_nudge`.
- Record reason codes and threshold comparisons.

5. `policy_check`
- Validate directive alignment.
- Validate allowed action scope.
- Validate no prohibited language in outbound draft.

6. `approval_loop`
- Submit action package for explicit review.
- Wait up to 30 minutes.
- On reject/timeout, emit blocked event and terminate.

7. `execute_actions`
- Send outbound message and apply SFDC updates only if approved.
- Use idempotency key `event_id` for side effects.

8. `emit_result`
- Emit `nrr.play.executed` when actions succeed.
- Emit `nrr.play.failed` on terminal execution failure.

## Optional Subagent Pattern
- Use subagents only for high-volume research/context collection.
- Subagents must have least-privilege tool access.
- Subagents cannot spawn additional subagents; chain from the main routine thread if multiple specialists are needed.

## Tool Contract
- Required tools:
- `contract_validator`
- `endgame_mcp`
- `endgame-cli`
- `salesforce_headless_360`
- `approval_loop`
- `event_emitter`

- Optional tools:
- `research_enrichment` for external company signals

## Policy Check Matrix
- `POL-001`: required fields present
- `POL-002`: event type supported
- `POL-003`: segment is low/no-touch
- `POL-004`: outbound template approved
- `POL-005`: SFDC mutations limited to allowed fields
- `POL-006`: approval decision is explicit and fresh (<30m)

## Failure Semantics
- Transport/tool transient error: retry up to 3 times with exponential backoff.
- Policy failure: no retries; emit blocked event.
- Approval timeout/reject: no side effects; emit blocked event.
- Execution terminal failure: emit failed event with `error_stage`.
- Routine trigger/API limit hit: emit machine-level retryable failure with preserved `event_id` and `trace_id`.
