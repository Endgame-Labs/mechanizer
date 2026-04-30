# Make Adapter (long-tail-account-coverage-machine)

![Long Tail Account Coverage Machine Diagram](../diagram.svg)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Ingest long-tail account signals via webhook and periodic sweep.
2. Normalize + dedupe to canonical contract.
3. Enrich context and score churn/expansion posture.
4. Route actions by risk band.
5. Run approval loop before outbound or CRM mutation modules.
6. Execute approved actions and emit executed/blocked terminal events.

## Operator Notes
- Keep max runs/minute conservative for long-tail account sweeps.
- Use replay for backfills after threshold adjustments.
- Keep blocked path strictly non-mutating.

## Approval Placement
- Approval loop is required before email and Salesforce modules.

## Format Parity
- Compatibility posture: `scenario.json` in this repo is a blueprint-style reference artifact, not a raw Make-exported scenario blueprint JSON.
- Importability limits/assumptions: direct `Import blueprint` is not guaranteed from this artifact; use a Make-exported blueprint JSON under 2 MB, then reconnect app connections and rebind environment resources (for example webhooks, data stores, and record IDs).
- Source docs: official Make blueprint docs (`https://help.make.com/blueprints`) and community release note on improved import UX (`https://community.make.com/t/feature-spotlight-improved-scenario-blueprint-import/106569`).

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/router
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/scenario-run-replay
