# Zapier Adapter (account-plan-generation-machine)

Zapier pattern for generating account plans with deterministic section builders and explicit approval before CRM or outbound writes.

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
1. Trigger from webhook (`/account-plan/events`) or schedule for rolling refresh.
2. Validate and normalize to `gtm_event_v1` in `Code by Zapier`.
3. Gate with `Filter by Zapier` on supported planning events.
4. Fetch context and directives from provider endpoints.
5. Build structured plan sections (`context`, `relationship_map`, `whitespace`, `plays`).
6. Run approval gate before any persistence or CRM mutation.
7. Branch with `Paths`:
- Approved: upsert plan + optional CRM write + emit `account.plan.generated`.
- Blocked/timeout: emit `account.plan.blocked` and notify ops channel.

## Approval/HITL Pattern
- Preferred: `Human in the Loop -> Request Approval` for manager review.
- Alternative: webhook call to external approval service if approvals are managed outside Zapier.
- Keep approval request payload compact: `event_id`, `account_id`, `plan_summary`, `proposed_mutations`, `trace`.

## Practical Zapier Notes
- `Paths` must be the final step; use Sub-Zaps for shared post-branch behavior.
- Use `Storage by Zapier` for dedupe and terminal status writes.
- Webhook burst traffic can be delayed; build caller retries with exponential backoff.

## References
- https://help.zapier.com/hc/en-us/articles/38731264910733-Collect-data-for-your-workflow-with-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/8496308527629-Create-reusable-Zap-steps-with-Sub-Zaps
- https://help.zapier.com/hc/en-us/articles/44391646192397-Choosing-the-right-way-to-make-API-requests-in-Zapier
- https://help.zapier.com/hc/en-us/articles/29972220283789-Webhooks-by-Zapier-rate-limits
- https://help.zapier.com/hc/en-us/articles/8496241726989-Replay-Zap-runs
