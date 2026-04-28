# Make Adapter (stage-change-deal-review-machine)

![Stage Change Deal Review Machine Diagram](../diagram.svg)

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

## Format Parity
- Compatibility posture: `scenario.json` in this repo is a blueprint-style reference artifact, not a raw Make-exported scenario blueprint JSON.
- Importability limits/assumptions: direct `Import blueprint` is not guaranteed from this artifact; use a Make-exported blueprint JSON under 2 MB, then reconnect app connections and rebind environment resources (for example webhooks, data stores, and record IDs).
- Source docs: official Make blueprint docs (`https://help.make.com/blueprints`) and community release note on improved import UX (`https://community.make.com/t/feature-spotlight-improved-scenario-blueprint-import/106569`).

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/router
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/overview-of-error-handling
- https://help.make.com/scenario-run-replay
