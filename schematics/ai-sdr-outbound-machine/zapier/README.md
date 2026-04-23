# Zapier Adapter (ai-sdr-outbound-machine)

Webhook-driven SDR outbound orchestration with smart cogs, approval gating, and safe branch execution.

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
1. Trigger on inbound events (`prospect.research_requested`, `account.intent_detected`, `response.received`).
2. Normalize to `gtm_event_v1`.
3. Pull context (intent, account history, enablement directives).
4. Compose outbound draft and channel recommendation.
5. Run approval gate before any outbound send or CRM write.
6. Branch with `Paths`:
- Approved: create draft/send through outbound tool, create CRM task, emit success event.
- Blocked/timeout: emit blocked event and route reviewer alert.

## Zapier-Specific Execution Notes
- Use `Storage by Zapier` for dedupe (`ai-sdr-outbound:${event_id}`) before side effects.
- For outbound APIs without secure app auth support in Webhooks, prefer API by Zapier.
- If burst traffic is expected, add `Delay After Queue` before outbound action steps.

## Approval Pattern
- Primary: `Human in the Loop -> Request Approval`.
- Fallback: external approval webhook for teams centralizing approvals outside Zapier.

## References
- https://help.zapier.com/hc/en-us/articles/38731226552845-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/44391646192397-Choosing-the-right-way-to-make-API-requests-in-Zapier
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/29972220283789-Webhooks-by-Zapier-rate-limits
- https://help.zapier.com/hc/en-us/articles/8496241726989-Replay-Zap-runs
