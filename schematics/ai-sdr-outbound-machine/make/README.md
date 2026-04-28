# Make Adapter (ai-sdr-outbound-machine)

![AI SDR Outbound Machine Diagram](../diagram.svg)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Receive outbound/reply lifecycle events over webhook.
2. Normalize to `gtm_event_v1`.
3. Enrich account/persona context and generate sequence drafts.
4. Iterate sequence steps and aggregate final outbound payload.
5. Route all outbound comms and CRM writes through approval loop.
6. Execute approved actions and emit routed output event.

## Operator Notes
- Keep sequential processing on to avoid duplicate sequence launches.
- Cap scenario run rate to protect downstream send APIs.
- Keep blocked path non-mutating and visible for ops review.

## Approval Placement
- Approval loop is mandatory before email send and CRM mutation modules.

## Format Parity
- Compatibility posture: `scenario.json` in this repo is a blueprint-style reference artifact, not a raw Make-exported scenario blueprint JSON.
- Importability limits/assumptions: direct `Import blueprint` is not guaranteed from this artifact; use a Make-exported blueprint JSON under 2 MB, then reconnect app connections and rebind environment resources (for example webhooks, data stores, and record IDs).
- Source docs: official Make blueprint docs (`https://help.make.com/blueprints`) and community release note on improved import UX (`https://community.make.com/t/feature-spotlight-improved-scenario-blueprint-import/106569`).

## References
- https://help.make.com/blueprints
- https://help.make.com/schedule-a-scenario
- https://help.make.com/iterator
- https://help.make.com/aggregator
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/scenario-run-replay
