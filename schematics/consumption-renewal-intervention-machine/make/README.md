# Make Adapter (consumption-renewal-intervention-machine)

![Consumption Renewal Intervention Machine Diagram](../diagram.svg)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Trigger daily renewal-risk sweep plus optional realtime webhook.
2. Normalize to canonical event payload.
3. Enrich account/renewal state and score intervention urgency.
4. Route to intervention play type and compose action plan.
5. Send Slack summary (always-on).
6. Run approval loop before optional outbound email or CRM updates.
7. Emit executed vs blocked terminal event.

## Operator Notes
- Keep schedule aligned with renewal ops cadence (default 07:00 PT).
- Use scenario run rate limits to avoid burst writes into CRM.
- Keep approval timeout explicit for async reviewer workflows.

## Approval Placement
- Approval loop must remain before optional action modules (`gmail`, `salesforce`).

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
