# Zapier Adapter (stage-change-deal-review-machine)

Zapier implementation for stage-change reviews with approval-gated CRM writeback.

## Artifact
- `zap.template.json`

## Core Flow
1. Trigger on stage-change event (webhook or Salesforce update).
2. Normalize/validate and dedupe by `event_id`.
3. Execute enrichment, scoring, and directive-alignment cogs.
4. Request approval before Salesforce mutation.
5. Branch:
- Approved: update opportunity + emit writeback event.
- Non-approved: post findings + emit findings event.

## References
- https://help.zapier.com/hc/en-us/articles/8496288690317-Trigger-Zaps-from-webhooks
- https://help.zapier.com/hc/en-us/articles/38731226552845-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
