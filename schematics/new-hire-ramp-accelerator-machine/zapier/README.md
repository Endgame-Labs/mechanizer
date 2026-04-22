# Zapier Adapter (new-hire-ramp-accelerator-machine)

Zapier implementation for new-hire onboarding package generation with approval before CRM or outbound updates.

## Artifact
- `zap.template.json`

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
