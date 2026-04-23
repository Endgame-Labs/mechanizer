# Zapier Adapter (deal-hygiene-machine)

Zapier implementation for deal hygiene scoring with a required approval gate before CRM writeback.

## Artifact
- `zap.template.json`

## Format Parity
- Intent: `zap.template.json` in this folder is a reference template for build guidance, not a direct Zapier account export JSON.
- Compatibility posture: treat this artifact as design-time documentation. Zapier JSON import/export is available on Team and Enterprise plans and expects Zapier-exported JSON; this file may require manual rebuild in the Zap editor before it can be exported/imported between accounts.
- Official docs:
  - https://help.zapier.com/hc/en-us/articles/8496308481933-Import-and-export-Zaps-in-your-Team-or-Enterprise-account
  - https://help.zapier.com/hc/en-us/articles/8496292155405-Share-a-template-of-your-Zap
- Public template source:
  - https://zapier.com/templates

## Recommended Zap Shape
1. Trigger from Salesforce record updates or inbound webhook events.
2. Normalize to `gtm_event_v1` and validate required fields.
3. Dedupe using `Storage by Zapier`.
4. Enrich with context, run scoring, and produce proposed opportunity changes.
5. Run approval (`Human in the Loop` preferred) before `Salesforce` update.
6. Use `Paths`:
- Approved: apply CRM updates and emit `deal.hygiene.remediated`.
- Rejected/timeout: emit `deal.hygiene.deferred` and notify reviewers.

## Practical Zapier Notes
- Keep `Paths` as the final step; no shared action block afterward.
- If a webhook producer is moved to a different Zap owner, refresh webhook URLs.
- Webhook processing can be delayed under high load even on HTTP 200; caller retries still required.

## Approval/HITL
- Request payload should include proposed field diffs and reason codes.
- Approval metadata to persist: `event_id`, `approver`, `decision`, `decision_at`, `trace_id`.

## References
- https://help.zapier.com/hc/en-us/articles/8496288690317-Trigger-Zaps-from-webhooks
- https://help.zapier.com/hc/en-us/articles/38731226552845-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/8496180919949-Filter-and-path-rules-in-Zaps
- https://help.zapier.com/hc/en-us/articles/29972220283789-Webhooks-by-Zapier-rate-limits
- https://help.zapier.com/hc/en-us/articles/8496196837261-How-is-task-usage-measured-in-Zapier
