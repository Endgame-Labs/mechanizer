# Make Adapter (nrr-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.
- Keep blueprint JSON under 2 MB and reconnect all apps after import.

## Scenario Shape
1. Ingest account signals from custom webhook and periodic rescoring schedule.
2. Normalize to `gtm_event_v1` and enforce idempotency.
3. Fetch account context and compute retention/expansion score.
4. Route into `critical`, `expansion`, `monitor` play paths.
5. Iterate recommended actions and aggregate approved action package.
6. Run approval loop before outbound email or CRM updates.
7. Execute approved side effects and emit terminal event.

## Operator Notes
- Enable sequential processing if you need deterministic per-account ordering.
- Keep max runs/minute below downstream email/CRM API thresholds.
- Store incomplete executions and dead-letter semantic failures.
- Use replay to backfill after rubric or scoring updates.

## Approval Placement
- Approval loop is mandatory before all outbound comms and CRM mutations.
- Blocked path is non-mutating and emits `nrr.play.blocked`.

## Format Parity
- Compatibility posture: `scenario.json` in this repo is a blueprint-style reference artifact, not a raw Make-exported scenario blueprint JSON.
- Importability limits/assumptions: direct `Import blueprint` is not guaranteed from this artifact; use a Make-exported blueprint JSON under 2 MB, then reconnect app connections and rebind environment resources (for example webhooks, data stores, and record IDs).
- Source docs: official Make blueprint docs (`https://help.make.com/blueprints`) and community release note on improved import UX (`https://community.make.com/t/feature-spotlight-improved-scenario-blueprint-import/106569`).

## References
- https://help.make.com/blueprints
- https://help.make.com/schedule-a-scenario
- https://help.make.com/router
- https://help.make.com/iterator
- https://help.make.com/aggregator
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/scenario-run-replay
- https://apps.make.com/gateway
