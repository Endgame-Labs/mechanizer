# Zapier Adapter (consumption-renewal-intervention-machine)

Zapier implementation for daily consumption-risk intervention planning with approval-gated outbound actions.

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
1. Trigger from daily schedule or inbound webhook event.
2. Validate `gtm_event_v1` and dedupe by `event_id`.
3. Enrich account context (usage, renewal, enablement directives).
4. Score intervention priority and compose plan.
5. Post required internal Slack summary.
6. Require approval before any customer-facing send or CRM write.
7. Branch to executed vs blocked terminal events.

## Zapier Notes
- Keep heavy data outside Zapier; pass compact scores and plan summaries.
- Use `Storage by Zapier` for dedupe and terminal status.
- `Paths` should be the final step.

## References
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/38731226552845-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/29972220283789-Webhooks-by-Zapier-rate-limits
