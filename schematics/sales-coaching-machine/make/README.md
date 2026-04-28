# Make Adapter (sales-coaching-machine)

![Sales Coaching Machine Diagram](../diagram.svg)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.
- Keep scenario blueprint below 2 MB and reconnect app connections post-import.

## Scenario Shape
1. Receive `call.completed` via custom webhook.
2. Normalize payload to canonical `gtm_event_v1`.
3. Enrich context and run directive alignment check.
4. Use router for recommendation outcomes (`coaching_task`, `escalate`, fallback).
5. Send all side-effecting actions through approval loop.
6. Approved route writes CRM task / escalation message.
7. Emit output event and dead-letter non-retryable errors.

## Operator Notes
- Run sequentially when multiple call events may target the same opportunity in short windows.
- Use scenario rate limit to protect CRM and Slack APIs.
- Keep incomplete execution retries for transport failures only.
- Use run replay after updating scoring thresholds or rubric mappings.

## Approval Placement
- Approval loop must stay before Salesforce task creation and outbound Slack escalation.

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
