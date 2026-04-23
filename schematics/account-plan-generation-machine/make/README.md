# Make Adapter (account-plan-generation-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Ingest planning triggers via webhook plus scheduled refresh.
2. Normalize and dedupe canonical event payload.
3. Build plan sections using cog endpoints.
4. Iterate generated sections and aggregate final plan package.
5. Run approval loop before CRM/doc mutations.
6. Approved route upserts plan and emits `account.plan.generated`.
7. Blocked route emits `account.plan.blocked` only.

## Operator Notes
- Keep schedule for broad refresh (for example every 6 hours).
- Use replay for safe backfills after plan-template changes.
- Keep Data Store keying on `event_id` to avoid duplicate writes.

## Approval Placement
- Approval loop must remain immediately before plan upsert modules.

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
