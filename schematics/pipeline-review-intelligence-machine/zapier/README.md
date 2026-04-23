# Zapier Adapter (pipeline-review-intelligence-machine)

Zapier implementation for pipeline review prep with smart-cog scoring, approval gating, and manager-ready summaries.

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

## Core Flow
1. Trigger from webhook or schedule.
2. Normalize payload, filter supported events, dedupe.
3. Execute smart cogs: account enrichment, deal scoring, directive alignment.
4. Compose manager review packet.
5. Require approval before outbound manager digests or CRM updates.
6. Emit executed/blocked terminal events.

## Zapier Notes
- Keep approval immediately before side effects.
- If shared post-branch actions are needed, use Sub-Zap calls in each branch.
- Use `Storage by Zapier` for dedupe and terminal state.

## References
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/38731226552845-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/8496196837261-How-is-task-usage-measured-in-Zapier
