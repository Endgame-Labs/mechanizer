# Routine Spec (ai-sdr-outbound-machine)

## Metadata
- routine_id: `ai_sdr_outbound_v2`
- input_contract: `gtm_event_v1`
- output_contract: `gtm_event_v1`
- objective: draft and execute approved outbound while routing qualified responses correctly.

## Supported Event Types
- `prospect.research_requested`
- `account.intent_detected`
- `response.received`

## Stage Plan
1. `validate_input`
- Validate contract and supported events.
- Invalid -> `sdr.sequence.failed_validation`.

2. `enrich_context`
- Pull account, persona, and intent signals.
- Normalize claim-evidence pairs.

3. `score_and_qualify`
- Compute outreach priority + qualification tier.
- High-risk strategic accounts marked for additional review.

4. `draft_outreach`
- Generate sequence steps, subject variants, and call-to-action map.
- Attach evidence refs for every non-trivial claim.

5. `policy_check`
- Validate directive compliance and prohibited-language checks.

6. `approval_loop`
- Required before `sequence_publish`, `email_send`, `crm_mutation`.
- Outcomes:
  - `approved` -> proceed
  - `rejected|expired|needs_info` -> emit `sdr.sequence.blocked`

7. `execute_actions`
- Publish/send outbound only on approved branch.
- On inbound responses, classify and route with thresholded qualification policy.

8. `emit_result`
- `sdr.sequence.ready`, `sdr.sequence.blocked`, `sdr.response.routed`, or `sdr.sequence.failed`.

## Practical Permission Pattern
- Early stages: read/enrichment tools only.
- Late stage (`execute_actions`): allow outbound + CRM tools.
- Store outbound idempotency fingerprint (`event_id` + `sequence_hash`).

## Subagent Pattern
- `prospect-researcher` subagent for high-volume background research.
- Keep subagent read-only + bounded output format (company, persona, evidence).
