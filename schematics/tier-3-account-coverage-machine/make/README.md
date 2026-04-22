# Make Adapter (tier-3-account-coverage-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Ingest tier-3 account signals via webhook and periodic sweep.
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

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/router
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/scenario-run-replay
