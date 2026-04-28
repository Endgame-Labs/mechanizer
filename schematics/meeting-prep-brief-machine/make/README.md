# Make Adapter (meeting-prep-brief-machine)

![Meeting Prep Brief Machine Diagram](../diagram.svg)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Receive meeting signals via webhook + scheduled near-term sweep.
2. Normalize and dedupe to `gtm_event_v1`.
3. Enrich meeting/account context.
4. Score prep priority and route brief depth.
5. Build brief sections with iterator + aggregator pattern.
6. Run approval loop before Slack/email delivery.
7. Deliver approved brief and emit completion/blocked event.

## Operator Notes
- Keep sequential processing for repeated updates on the same meeting.
- Add idempotency key from `event_id` to avoid duplicate brief sends.
- Keep dead-letter route for template/rendering failures.

## Approval Placement
- Approval loop must stay directly before Slack/email modules.

## Format Parity
- Compatibility posture: `scenario.json` in this repo is a blueprint-style reference artifact, not a raw Make-exported scenario blueprint JSON.
- Importability limits/assumptions: direct `Import blueprint` is not guaranteed from this artifact; use a Make-exported blueprint JSON under 2 MB, then reconnect app connections and rebind environment resources (for example webhooks, data stores, and record IDs).
- Source docs: official Make blueprint docs (`https://help.make.com/blueprints`) and community release note on improved import UX (`https://community.make.com/t/feature-spotlight-improved-scenario-blueprint-import/106569`).

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/router
- https://help.make.com/iterator
- https://help.make.com/aggregator
- https://help.make.com/overview-of-error-handling
- https://help.make.com/scenario-run-replay
