# Zapier Adapter (account-health-audit-machine)

![Account Health Audit Machine Diagram](../diagram.svg)

Zapier implementation for recurring account health audits with deterministic scoring plus optional smart-cog enrichment.

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
1. Trigger from `Schedule by Zapier` (weekday audit) or `Webhooks by Zapier` (on-demand audit request).
2. Normalize payload to `gtm_event_v1` in `Code by Zapier`.
3. Deduplicate with `Storage by Zapier` key `account-health-audit:${event_id}`.
4. Pull context via webhook action (CRM, product telemetry, enablement directives).
5. Run scoring/reasoning cogs and build a narrative roadmap.
6. Route internal alerts (Slack/email) and emit `account.health.audit.completed`.
7. Persist terminal status in `Storage by Zapier`.

## Practical Zapier Notes
- Prefer `Catch Hook` for parsed JSON. Use `Catch Raw Hook` only if you need headers/raw body (2 MB max raw payload).
- Keep branching in a final `Paths` step. If you need shared post-branch behavior, call a Sub-Zap.
- `Filter` and `Paths` do not consume tasks; successful actions do.
- For transient downstream failures, enable Autoreplay (Professional+).
- Keep all external write calls idempotent with `event_id`.

## Context Provider Guidance
- Context can come from Endgame MCP/CLI, Salesforce Headless 360, or other providers.
- Keep provider-specific fields in `attributes.context_providers[]` so the rest of the Zap stays portable.

## References
- https://help.zapier.com/hc/en-us/articles/8496288690317-Trigger-Zaps-from-webhooks
- https://help.zapier.com/hc/en-us/articles/8496288555917-Add-branching-logic-to-Zaps-with-Paths
- https://help.zapier.com/hc/en-us/articles/8496180919949-Filter-and-path-rules-in-Zaps
- https://help.zapier.com/hc/en-us/articles/8496310939021-Use-JavaScript-code-in-Zaps
- https://help.zapier.com/hc/en-us/articles/29971850476173-Code-by-Zapier-rate-limits
- https://help.zapier.com/hc/en-us/articles/29972220283789-Webhooks-by-Zapier-rate-limits
- https://help.zapier.com/hc/en-us/articles/8496196837261-How-is-task-usage-measured-in-Zapier
- https://help.zapier.com/hc/en-us/articles/8496241726989-Replay-Zap-runs
