# Routine Spec (meeting-prep-brief-machine)

## Metadata
- routine_id: `meeting_prep_brief_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: generate accurate meeting brief and deliver through approved channels.

## Supported Events
- `meeting.scheduled`
- `account.exec_meeting_booked`
- `opportunity.stage_changed`

## Stage Plan
1. `validate_input`
- Validate required fields and meeting window.
- Invalid -> `meeting.prep_brief.failed_validation`.

2. `enrich_context`
- Fetch meeting metadata, account state, recent interactions, key risks.

3. `select_depth`
- Choose `executive_brief`, `full_brief`, or `light_brief`.
- Record threshold reasons.

4. `compose_brief`
- Build sections: objective, state, risks, talk track, asks.
- Attach evidence refs.

5. `policy_check`
- Run directive alignment and prohibited-content checks.

6. `approval_loop` (conditional)
- Required for executive/high-severity cases before `slack_send`/`email_send`.

7. `deliver`
- Execute idempotent channel sends.

8. `emit_result`
- Success: `meeting.prep_brief.delivered`.
- Blocked: `meeting.prep_brief.blocked`.
- Failure: `meeting.prep_brief.failed`.

## Subagent Pattern
- Optional read-only `background-researcher` for long account timelines.
- Keep output bounded to structured summary fields.
