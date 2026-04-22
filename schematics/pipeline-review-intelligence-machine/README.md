# Pipeline Review Intelligence Machine

## Purpose
Prepare weekly pipeline inspection output with consistent coverage of stale deals, missing next steps, single-threading exposure, and manager-level action summaries.

## Where It Fits
Use this machine when forecast and inspection meetings are slowed by manual spreadsheet prep and inconsistent pipeline review checks.

## Primary KPIs
- Pipeline review prep time reduction.
- Reduction in stale open opportunities.
- Increase in opportunities with explicit next-step date and owner.
- Reduction in single-threaded late-stage opportunities.

## Trigger Models
- Scheduled weekly prep:
  - Monday run generates manager summary pack for current pipeline window.
- Event-assisted refresh:
  - `pipeline.review.requested`, `deal.updated`, `activity.logged` can refresh impacted rows between weekly runs.

## Required Context Layers
- Endgame MCP + `endgame-cli`:
  - Pull account timeline, owner notes, interaction context, and directive references.
- Salesforce Headless 360:
  - Opportunity stage, close date, last activity date, next-step fields, and owner hierarchy.
- Conversation and engagement systems:
  - Gong/call signal freshness and multi-thread coverage hints.

## End-to-End Flow (Canonical)
1. Ingest trigger as `gtm_event_v1`.
2. Build opportunity context (`enrich_account_health`).
3. Score review risk and prioritization (`deal_score_reasoner`).
4. Check manager-summary guidance against directives (`directive_alignment`).
5. Draft manager summary and rep action blocks (`compose_outreach_message`).
6. Route critical flags to owner/manager destinations (`route_exec_alert`).
7. Approval-gate outbound summary/send actions (`approval_loop`).
8. Emit terminal review event (`pipeline.review.prep.completed` or `pipeline.review.prep.deferred`).

## Smart Cogs Used
- `enrich_account_health`: enrich freshness, engagement, and risk indicators.
- `deal_score_reasoner`: score stale-risk and review urgency.
- `directive_alignment`: enforce approved language and policy constraints.
- `compose_outreach_message`: build manager-ready summary sections.
- `route_exec_alert`: route high-risk flags.
- `approval_loop`: required before outbound summary distribution or high-impact CRM actions.

## Example Input/Output
Input event (simplified):
```json
{
  "event_type": "pipeline.review.requested",
  "source": "scheduler",
  "subject": { "entity_type": "pipeline", "entity_id": "team-west" },
  "attributes": { "review_window_start": "2026-04-20", "review_window_end": "2026-04-26" }
}
```

Output event (simplified):
```json
{
  "event_type": "pipeline.review.prep.completed",
  "attributes": {
    "stale_deal_count": 14,
    "missing_next_step_count": 9,
    "single_threaded_count": 6,
    "manager_summary_id": "summary_2026w17",
    "approval_status": "approved"
  }
}
```

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`:
  - Keep deterministic canonical mapping for `gtm_event_v1`.
  - Place `approval_loop` directly before outbound summary delivery and mutation side effects.
- `agentic/` and `claude-routines/`:
  - Keep enrichment, scoring, alignment, summary generation, routing, and approval as explicit phases.
- `claw-like/`:
  - Use `HEARTBEAT.md` schedule for weekly prep plus stale-run alerting.

## ChatGPT Workspace Agents Support
- ChatGPT/Slack:
  - Supported for manager and seller-facing review summaries with Slack delivery and thread follow-up.
- Cloud/background runs:
  - Weekly prep and ad-hoc refresh runs can execute in cloud background mode for long-running enrichment/scoring phases.
- Approval gates:
  - `approval_loop` remains mandatory before outbound summary distribution or any CRM mutation-capable action.
- Governance/visibility:
  - Keep run logs, tool-call traces, and approval decisions visible to machine owners for audit and replay-safe operations.
