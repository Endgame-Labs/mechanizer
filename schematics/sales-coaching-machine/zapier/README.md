# Zapier Adapter (sales-coaching-machine)

This adapter uses a webhook trigger from call-recording systems and enforces directive alignment plus approval-gated CRM writeback.

## Implementation Steps
1. Create a Zap named `Sales Coaching - Call Completed`.
2. Trigger: `Webhooks by Zapier` -> `Catch Hook` on path `sales-coaching-call-completed`.
3. Add `Filter by Zapier`:
- `type` exactly matches `call.completed`
- `call.opportunity_id` exists
4. Action: `Code by Zapier` to normalize trigger payload to `gtm_event_v1`.
5. Action: `Webhooks by Zapier` POST to Endgame context endpoint.
6. Action: `Webhooks by Zapier` POST to directive alignment endpoint.
7. Action: `Webhooks by Zapier` POST to approval request endpoint.
8. Action: `Paths by Zapier`:
- Path A when alignment `status=pass`, `score>=0.85`, and `approval_status=approved`.
- Path B otherwise.
9. Path A action: create Salesforce task.
10. Path B action: post Slack escalation for manager review.
11. Final path action(s): emit output event (`coaching.recommendation.created` when approved, `coaching.recommendation.blocked` otherwise).

## Field Mapping Example (`gtm_event_v1`)
- `id` -> `event_id`
- `type` -> `event_type`
- `call.id` -> `subject.id`
- `call.occurred_at` -> `occurred_at`
- `call.opportunity_id` -> `attributes.opportunity_id`
- `call.rep_email` -> `attributes.rep_email`
- `{{zap_meta_timestamp}}` -> `ingested_at`

## Guardrails
- Reject if `event_type != call.completed`.
- Reject if missing `opportunity_id` or `rep_email`.
- Skip CRM write if directive alignment fails.
- Skip CRM write if approval status is not approved.
- Always preserve `trace_id` in every downstream request.

## Zapier Runtime Capabilities and Limits (verified 2026-04-22)
- Paths:
  - Max 10 branches per path group.
  - Max 3 nested Paths steps per Zap.
  - Paths execute sequentially left-to-right.
  - Paths should be final; common post-branch steps must be duplicated or moved to Sub-Zaps.
- Filters:
  - Failing filter stops all downstream actions.
  - Filters and Paths do not count as task usage.
- Code:
  - Code by Zapier supports JS/Python; JS runtime is Node.js 22.
  - Code I/O cap is 6 MB.
  - Runtime/throughput limits vary by plan (Enterprise up to 2 min script runtime, paid tiers up to 225 Code executions/10s).
- Webhooks:
  - Catch Raw Hook request body max: 2 MB.
  - Trigger payload cap: 10 MB. Webhook action cap: 5 MB.
  - Webhooks rate limits include 20,000 requests/5 min per user.
- Retry and replay:
  - Autoreplay attempts failed errored steps up to 5 times with increasing intervals.
  - Filter/Paths are never replayed.
- Templates:
  - Classic shared templates exclude field values and do not support Zaps containing Code steps.
  - Guided templates preserve configured values and present a setup wizard.
- Import/export:
  - Team/Enterprise-only account capability and JSON-only file format.
