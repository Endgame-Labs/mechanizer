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

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/iterator
- https://help.make.com/aggregator
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/scenario-run-replay
- https://help.make.com/data-stores
