# Zapier Adapter (nrr-machine)

Zapier implementation for low-touch/no-touch NRR orchestration with scoring, approval gating, and idempotent execution.

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
1. Trigger from NRR signal webhook or scheduled cohort sweep.
2. Validate and normalize to `gtm_event_v1`.
3. Filter to low-touch/no-touch cohorts.
4. Pull context and compute score/play.
5. Build action plan (outbound + CRM updates).
6. Require approval before outbound send or Salesforce mutation.
7. Branch with `Paths`:
- Approved: execute actions + emit `nrr.play.executed`.
- Blocked/timeout: emit `nrr.play.blocked`.

## Practical Zapier Notes
- Use `Storage by Zapier` for dedupe and terminal status.
- Add observability write step (Tables or webhook log sink) in each branch.
- Keep path rules mutually exclusive to avoid accidental multi-branch execution.

## Approval/HITL
- Preferred: `Human in the Loop` for human reviewer decision.
- Fallback: external approval service via webhook.
- Approval payload should include `score`, `play`, and explicit proposed actions.

## References
- https://help.zapier.com/hc/en-us/articles/38731226552845-Human-in-the-Loop
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/8496180919949-Filter-and-path-rules-in-Zaps
- https://help.zapier.com/hc/en-us/articles/8496196837261-How-is-task-usage-measured-in-Zapier
- https://help.zapier.com/hc/en-us/articles/29971850476173-Code-by-Zapier-rate-limits
- https://help.zapier.com/hc/en-us/articles/29972220283789-Webhooks-by-Zapier-rate-limits
- https://help.zapier.com/hc/en-us/articles/8496241726989-Replay-Zap-runs
