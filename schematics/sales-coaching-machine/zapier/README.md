# Zapier Adapter (sales-coaching-machine)

Zapier implementation for post-call coaching recommendations with directive alignment and approval-gated CRM updates.

## Artifact
- `zap.template.json`

## Format Parity
- Intent: `zap.template.json` in this folder is a reference template for build guidance, not a direct Zapier account export JSON.
- Compatibility posture: treat this artifact as design-time documentation. Zapier JSON import/export is available on Team and Enterprise plans and expects Zapier-exported JSON; this file may require manual rebuild in the Zap editor before it can be exported/imported between accounts.
- Official docs:
  - https://help.zapier.com/hc/en-us/articles/8496308481933-Import-and-export-Zaps-in-your-Team-or-Enterprise-account
  - https://help.zapier.com/hc/en-us/articles/8496292155405-Share-a-template-of-your-Zap
- Public template source:
  - https://zapier.com/templates

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
