# Zapier Adapter (sales-coaching-machine)

Zapier implementation for post-call coaching recommendations with directive alignment and approval-gated CRM updates.

## Artifact
- `zap.template.json`

## Recommended Zap Shape
1. Trigger on call-completed webhook from recording platform.
2. Filter invalid payloads and normalize to `gtm_event_v1`.
3. Fetch context (call transcript summary, enablement directives, opportunity state).
4. Run directive alignment and coaching recommendation synthesis.
5. Gate with approval before creating Salesforce tasks or outbound manager notifications.
6. Branch with `Paths`:
- Approved + aligned: create coaching task, emit `coaching.recommendation.created`.
- Blocked/misaligned: escalate and emit `coaching.recommendation.blocked`.

## Practical Zapier Notes
- For transcript-heavy payloads, send only compact summaries into Zapier and keep full text in upstream storage.
- Use `Storage by Zapier` for dedupe and to prevent duplicate coaching tasks.
- Keep path predicates mutually exclusive and explicit.

## Approval/HITL
- Preferred: `Human in the Loop`.
- Fallback: external approval endpoint.
- Persist approver decision + alignment score for later QA.

## References
- https://help.zapier.com/hc/en-us/articles/8496288690317-Trigger-Zaps-from-webhooks
- https://help.zapier.com/hc/en-us/articles/38731226552845-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/8496310939021-Use-JavaScript-code-in-Zaps
- https://help.zapier.com/hc/en-us/articles/29971850476173-Code-by-Zapier-rate-limits
- https://help.zapier.com/hc/en-us/articles/8496241726989-Replay-Zap-runs
