# Make Adapter (account-health-audit-machine)

![Account Health Audit Machine Diagram](../diagram.svg)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style reference for scheduled deterministic audits.

## Scenario Shape
1. Trigger from weekday schedule and optional ad hoc webhook.
2. Normalize to `gtm_event_v1` and dedupe by run key.
3. Fetch account health context and run scoring/alignment cogs.
4. Iterate risk factors and aggregate narrative evidence package.
5. Emit `account.health.audit.completed` event.
6. Persist run summary for auditability.

## Operator Notes
- This machine is read/analyze/emit by default and does not require approval loop.
- Keep sequential processing on for deterministic ordering.
- Use replay to validate scoring changes against historical triggers.

## Format Parity
- Compatibility posture: `scenario.json` in this repo is a blueprint-style reference artifact, not a raw Make-exported scenario blueprint JSON.
- Importability limits/assumptions: direct `Import blueprint` is not guaranteed from this artifact; use a Make-exported blueprint JSON under 2 MB, then reconnect app connections and rebind environment resources (for example webhooks, data stores, and record IDs).
- Source docs: official Make blueprint docs (`https://help.make.com/blueprints`) and community release note on improved import UX (`https://community.make.com/t/feature-spotlight-improved-scenario-blueprint-import/106569`).

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/iterator
- https://help.make.com/aggregator
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/scenario-run-replay
- https://help.make.com/data-stores
