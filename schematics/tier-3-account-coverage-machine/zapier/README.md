# Zapier Adapter (tier-3-account-coverage-machine)

Zapier implementation for tier-3 account coverage with segmentation, scoring, and approval-gated action execution.

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
1. Trigger from webhook or scheduled cohort sweep.
2. Validate/normalize and dedupe.
3. Filter to low-touch/no-touch segments.
4. Enrich context + score churn/expansion posture.
5. Compose outreach recommendation.
6. Require approval before outbound or CRM mutations.
7. Emit executed or blocked terminal event.

## Zapier Notes
- Keep path conditions explicit and mutually exclusive.
- Use `Storage by Zapier` dedupe before all side effects.
- Prefer Human in the Loop when review latency is acceptable.

## References
- https://help.zapier.com/hc/en-us/articles/38731226552845-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/8496196837261-How-is-task-usage-measured-in-Zapier
