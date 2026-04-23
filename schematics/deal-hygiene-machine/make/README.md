# Make Adapter (deal-hygiene-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style reference for import into Make.
- Reconnect app connections after import and keep blueprint JSON under 2 MB.

## Scenario Shape
1. Trigger from custom webhook (`deal-hygiene-machine`) and optional scheduled sweep.
2. Normalize to `gtm_event_v1`.
3. Use Data Store idempotency guard (`Get a record` + skip duplicates).
4. Enrich + score through HTTP smart-cog endpoints.
5. Use `Flow control > Router` for severity (`critical`, `standard`, fallback).
6. Build proposed field mutations and send to approval loop.
7. Only approved route updates Salesforce.
8. Emit terminal event and write run summary record.

## Operator Notes
- Keep scenario sequential when ordering by `subject.id` matters.
- If burst traffic exceeds rate limits, cap max runs/minute to let Make queue runs.
- Add module-level error handlers and route non-retryable failures to dead-letter publishing.
- Keep replay/backfill enabled for remediation after mapping fixes.

## Approval Placement
- Approval loop must remain immediately before all CRM mutation modules.
- Deferred/rejected approvals emit `deal.hygiene.deferred` only.

## Format Parity
- Compatibility posture: `scenario.json` in this repo is a blueprint-style reference artifact, not a raw Make-exported scenario blueprint JSON.
- Importability limits/assumptions: direct `Import blueprint` is not guaranteed from this artifact; use a Make-exported blueprint JSON under 2 MB, then reconnect app connections and rebind environment resources (for example webhooks, data stores, and record IDs).
- Source docs: official Make blueprint docs (`https://help.make.com/blueprints`) and community release note on improved import UX (`https://community.make.com/t/feature-spotlight-improved-scenario-blueprint-import/106569`).

## References
- https://help.make.com/blueprints
- https://help.make.com/schedule-a-scenario
- https://help.make.com/router
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/overview-of-error-handling
- https://help.make.com/scenario-run-replay
- https://apps.make.com/gateway
- https://help.make.com/data-stores
