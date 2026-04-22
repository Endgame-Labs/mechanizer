# Zapier Adapter (stage-change-deal-review-machine)

## Reference Artifact
- `zap.template.json`: template metadata and step contract for a multi-step Zap.

## Trigger Mapping
- Trigger app/event: `Webhooks by Zapier -> Catch Hook` (or Salesforce updated opportunity trigger).
- Normalize payload to canonical `gtm_event_v1` in code step.

## Transform and Cog Steps
1. Normalize and validate envelope.
2. `enrich_account_health`.
3. `deal_score_reasoner`.
4. `directive_alignment`.
5. `route_exec_alert`.
6. `approval_loop`.
7. Approved path writes CRM updates and emits writeback event.
8. Non-approved path posts Slack findings and emits findings event.

## Approval Loop Placement
- Approval gate must be immediately before CRM mutation steps.
- Non-approved branch is read-only plus Slack findings output.
