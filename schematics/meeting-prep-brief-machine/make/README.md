# Make Adapter (meeting-prep-brief-machine)

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

## References
- https://help.make.com/schedule-a-scenario
- https://help.make.com/router
- https://help.make.com/iterator
- https://help.make.com/aggregator
- https://help.make.com/overview-of-error-handling
- https://help.make.com/scenario-run-replay
