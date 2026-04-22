# Make Adapter (stage-change-deal-review-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Receive stage-change events via webhook and optional periodic sweep.
2. Normalize to canonical event schema and dedupe.
3. Enrich deal context and score stage-change risk.
4. Route findings by severity and build suggested updates.
5. Run approval loop before CRM writeback or outbound findings.
6. Approved path updates Salesforce.
7. Non-approved path posts Slack findings and emits deferred event.

## Operator Notes
- Sequential processing is recommended for rapid stage transitions.
- Keep route filters explicit for stage movement and forecast category.
- Use dead-letter route for contract violations or malformed payloads.

## Approval Placement
- Approval loop must remain before Salesforce updates and outbound findings.

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/router
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/overview-of-error-handling
- https://help.make.com/scenario-run-replay
