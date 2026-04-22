# Make Adapter (account-health-audit-machine)

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

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/iterator
- https://help.make.com/aggregator
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/scenario-run-replay
- https://help.make.com/data-stores
