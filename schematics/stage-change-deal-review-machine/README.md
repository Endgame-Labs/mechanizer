# Stage Change Deal Review Machine

## Purpose
Run a deterministic deal review when an opportunity advances stage, then either apply approved CRM writeback or post Slack findings for seller action.

## Where It Fits
Use this machine when stage progression quality is inconsistent and leadership needs a contract-first review gate for qualification, risk, and required field completeness.

## Primary KPIs
- Median minutes from stage change to review completion.
- Stage changes passing qualification completeness standards.
- High-risk stage promotions surfaced to manager Slack channels.

## Trigger Models
- Realtime trigger:
  - `deal.stage_changed` and `opportunity.stage_changed` events.
- Batch trigger:
  - Scheduled sweep for missed or delayed stage-change events.

## Required Context Layers
- Endgame MCP + `endgame-cli`:
  - Pull timeline, notes, interactions, and directive context for the current deal.
- CRM state:
  - Opportunity stage history, required qualification fields, and owner/manager mapping.
- Optional call evidence:
  - Gong/meeting signal references that support qualification confidence.

## End-to-End Flow (Canonical)
1. Ingest stage-change trigger as `gtm_event_v1`.
2. Enrich context (`enrich_account_health`) and score quality/risk (`deal_score_reasoner`).
3. Evaluate policy and operating directives (`directive_alignment`).
4. Route findings and escalation (`route_exec_alert`).
5. Pass proposed writeback through mandatory `approval_loop`.
6. Approved branch applies writeback and emits `deal.stage_review.writeback_applied`.
7. Non-approved branch posts Slack findings and emits `deal.stage_review.findings_posted`.

## Smart Cogs Used
- `enrich_account_health`: normalize account/deal context and timeline inputs.
- `deal_score_reasoner`: produce qualification confidence, risk band, and missing-field findings.
- `directive_alignment`: enforce stage-progression policy and approval constraints.
- `route_exec_alert`: route findings to owner, manager, and escalation channels.
- `approval_loop`: hard gate before any CRM mutation side effect.

## Example Input/Output
Input event (simplified):
```json
{
  "event_type": "opportunity.stage_changed",
  "source": "salesforce_headless_360",
  "subject": { "entity_type": "opportunity", "entity_id": "006xx00000ABC123" },
  "attributes": {
    "from_stage": "Qualification",
    "to_stage": "Proposal",
    "required_fields": ["next_step", "close_date", "champion_name"]
  }
}
```

Output event (writeback path, simplified):
```json
{
  "event_type": "deal.stage_review.writeback_applied",
  "attributes": {
    "qualification_confidence": "high",
    "risk_band": "medium",
    "missing_fields": [],
    "approval_status": "approved"
  }
}
```

Output event (Slack findings path, simplified):
```json
{
  "event_type": "deal.stage_review.findings_posted",
  "attributes": {
    "qualification_confidence": "low",
    "risk_band": "high",
    "missing_fields": ["champion_name", "mutual_action_plan"],
    "approval_status": "rejected"
  }
}
```

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`:
  - Keep schema validation and idempotency before cog execution.
  - Place `approval_loop` immediately before CRM writeback.
- `agentic/` and `claude-routines/`:
  - Keep stages explicit: validate, enrich, score, align, route, approve, execute.
- `claw-like/`:
  - Use heartbeat schedule for missed-event backfill and stale-run alerting.

## ChatGPT Workspace Agents Support
- ChatGPT/Slack:
  - Supported for findings delivery to manager and seller channels, including threaded follow-up on stage-review outcomes.
- Cloud/background runs:
  - Stage-change review and backfill sweeps can run in cloud/background mode when enrichment or approvals extend runtime.
- Approval gates:
  - `approval_loop` remains the required authorization gate before any CRM writeback action.
- Governance/visibility:
  - Preserve workspace-visible traces for tool calls, approval decisions, and emitted stage-review events.
