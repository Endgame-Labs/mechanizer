# Zapier Adapter (renewal-risk-monitoring-machine)

Zapier implementation for renewal risk monitoring with required internal alerts and approval-gated customer-facing actions.

## Artifact
- `zap.template.json`

## Core Flow
1. Trigger from schedule or inbound webhook.
2. Validate + dedupe.
3. Enrich context and calculate renewal risk score.
4. Send required CSM Slack alert and optional exec escalation.
5. Request approval before outbound or CRM changes.
6. Emit executed/blocked event.

## References
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/38731226552845-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/29972220283789-Webhooks-by-Zapier-rate-limits
