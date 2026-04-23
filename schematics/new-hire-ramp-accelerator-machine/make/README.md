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
