# Zapier Adapter (new-hire-ramp-accelerator-machine)

Zapier implementation for new-hire onboarding package generation with approval before CRM or outbound updates.

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
1. Trigger from webhook or scheduled reconciliation.
2. Validate contract, filter supported events, dedupe on `event_id`.
3. Build onboarding package from context providers.
4. Request approval before writing package records or CRM updates.
5. Branch approved/blocked and emit terminal event.

## Zapier Notes
- Use `Storage by Zapier` for dedupe.
- Keep `Paths` as final step.
- For shared post-branch actions, use Sub-Zaps.

## References
- https://help.zapier.com/hc/en-us/articles/8496308527629-Create-reusable-Zap-steps-with-Sub-Zaps
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/38731264910733-Collect-data-for-your-workflow-with-Human-in-the-Loop
