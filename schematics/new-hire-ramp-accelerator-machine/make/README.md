# Make Adapter (new-hire-ramp-accelerator-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Receive onboarding trigger via webhook plus reconciliation schedule.
2. Normalize and dedupe to canonical event contract.
3. Build onboarding package modules and skill checklist blocks.
4. Iterate sections and aggregate final onboarding payload.
5. Run approval loop before creating outbound onboarding comms/tasks.
6. Execute approved actions and emit generated/blocked event.

## Operator Notes
- Keep schedule enabled for delayed HRIS/CRM updates.
- Rate-limit runs if downstream LMS/CRM APIs are strict.
- Keep blocked path visible for enablement ops review.

## Approval Placement
- Approval loop must remain before email/task side effects.

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/iterator
- https://help.make.com/aggregator
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/scenario-run-replay
