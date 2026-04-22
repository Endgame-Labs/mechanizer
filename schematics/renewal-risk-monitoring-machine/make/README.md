# Make Adapter (renewal-risk-monitoring-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Trigger daily renewal-risk sweep and optional realtime webhook.
2. Normalize and dedupe canonical event payload.
3. Enrich account context and compute renewal risk score.
4. Route into risk bands and generate recommended play.
5. Send CSM Slack notification.
6. Run approval loop before outbound email or CRM writes.
7. Emit executed or blocked terminal event.

## Operator Notes
- Keep daily schedule aligned to regional renewal operations.
- Use run rate cap to avoid flooding CRM in large cohort runs.
- Keep risk-threshold routing deterministic and versioned.

## Approval Placement
- Approval loop must remain before email + Salesforce modules.

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/router
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/overview-of-error-handling
- https://help.make.com/scenario-run-replay
