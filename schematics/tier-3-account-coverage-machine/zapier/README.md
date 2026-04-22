# Zapier Adapter (tier-3-account-coverage-machine)

Zapier implementation for tier-3 account coverage with segmentation, scoring, and approval-gated action execution.

## Artifact
- `zap.template.json`

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
