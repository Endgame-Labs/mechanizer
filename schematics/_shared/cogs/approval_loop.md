# approval_loop Smart Cog

Contract-bound human approval gate for high-impact side effects (CRM writes, outbound sends, commercial updates).

## Purpose
- Pause execution before sensitive actions.
- Prompt a human approver in a configured channel.
- Resume execution after callback with explicit approval decision metadata.

## Supported Human Prompt Channels
- `claude_ask_user_question`
  - Use a Claude routine ask-user step to capture approve/reject with reason.
- `slack_form`
  - Send a Slack interactive form or message buttons for approve/reject and reason.
- `webhook_callback`
  - POST approval request to bespoke UI and wait for signed callback payload.

## Input Contract Notes
Required:
- `trace.trace_id`
- `subject.id`
- `attributes.proposed_action`
- `attributes.risk_level`

Optional approval prompt controls:
- `attributes.approval_prompt.channel`
- `attributes.approval_prompt.prompt_text`
- `attributes.approval_prompt.form_schema`
- `attributes.approval_prompt.callback_url`
- `attributes.approval_prompt.callback_method`
- `attributes.approval_prompt.callback_auth_ref`
- `attributes.approval_prompt.timeout_seconds`

## Output Contract Notes
- `attributes.approval_request_id`
- `attributes.approval_channel`
- `attributes.approval_status` (`approved`, `rejected`, `timeout`, `failed`)
- `attributes.approval_decision_by`
- `attributes.approval_decision_at`
- `attributes.approval_reason`
- `attributes.approval_callback_status` (`delivered`, `pending`, `failed`, `n/a`)

## Callback Semantics (`webhook_callback`)
- Cog posts approval payload to `callback_url`.
- External UI callback must include:
  - `approval_request_id`
  - `approval_status`
  - `approval_decision_by`
  - `approval_decision_at`
  - `approval_reason`
  - `trace.trace_id`
- Callback payload must be authenticated using `callback_auth_ref`.
- If callback does not arrive before timeout, emit `approval_status: timeout`.

## Adapter Mapping Guidance
- `agentic`: explicit wait state and callback listener.
- `claude-routines`: ask-user routine for direct human decision capture.
- `n8n/zapier/tray/make`: Slack form or webhook callback branch on `approval_status`.
- `claw-like`: persist pending approval state and rehydrate on next heartbeat tick.
