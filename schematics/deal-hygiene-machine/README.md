# Deal Hygiene Machine

![deal-hygiene-machine Diagram](./diagram.svg)

## Purpose
Detect, score, and remediate CRM data-quality drift before it affects forecast accuracy, pipeline inspection, and downstream automation.

## Where It Fits
Use this machine when your team needs deterministic hygiene checks with selective agentic reasoning for ambiguous records.

## Primary KPIs
- Reduction in stale or invalid open opportunities.
- Forecast review prep time reduction.
- Median time-to-remediation for high-severity hygiene issues.

## Trigger Models
- Realtime trigger:
  - Opportunity/account changes from Salesforce Headless 360 event streams.
- Batch trigger:
  - Scheduled sweep (`claw-like` heartbeat or scheduler) for drift detection and backfill reconciliation.

## Required Context Layers
- Endgame MCP + `endgame-cli`:
  - Pull notes, Slack account chatter, interaction summaries, directives, and dataset query results.
- Salesforce Headless 360:
  - Source of truth for object state and writeback actions.
- Optional enrichment:
  - Exa/public web context for company-level changes that may explain data drift.

## Integration Callouts
- Core context plane:
  - Endgame MCP/CLI for context graph, extracted facts, hybrid retrieval, and directive grounding.
- CRM/action layer:
  - Salesforce Headless 360 + CRM APIs for event triggers and writebacks.
- Call recorder inputs:
  - Gong/Zoom/Chorus signals can provide post-call evidence for hygiene validation.
- Enablement alignment:
  - Seismic/Highspot directives can be checked before policy-sensitive changes.
- Research enrichment:
  - Exa/Perplexity/Parallel can add public-company context for ambiguous hygiene cases.

## End-to-End Flow (Canonical)
1. Ingest event as `gtm_event_v1`.
2. Normalize and enrich account/deal context (`enrich_account_health`).
3. Calculate hygiene risk and priority (`deal_score_reasoner`).
4. Validate proposed fixes against directives (`directive_alignment`).
5. Route severity and owners (`route_exec_alert`).
6. Gate all SFDC writes through `approval_loop`.
7. Execute approved writebacks and emit normalized completion event.

## Smart Cogs Used
- `enrich_account_health`:
  - Adds health/risk features from telemetry + CRM context.
  - Example: marks low activity + stale close date as elevated hygiene risk.
- `deal_score_reasoner`:
  - Produces score band and recommended remediation play.
  - Example: `critical` score routes to same-day owner task + manager alert.
- `directive_alignment`:
  - Confirms proposed update or recommendation aligns to current operating directives.
  - Example: blocks automatic stage rollback if directive requires manager sign-off.
- `route_exec_alert`:
  - Maps severity to owner/manager/exec destinations.
  - Example: high-risk enterprise opp sends alert to AE + regional VP channel.
- `approval_loop`:
  - Mandatory gate before SFDC write/update actions.
  - Example: proposed field corrections enter review queue; only approved actions execute.

## Pluggable Interfaces
- Context providers (swap-in):
  - `endgame_mcp`, `endgame_cli`, `salesforce_headless_360`, `salesforce`, `hubspot`, `gong`.
- Action providers (swap-in):
  - SFDC REST/Bulk APIs, workflow-native tasks (n8n/Zapier/Tray/Make), Slack/email alerts.
- Approval providers (swap-in):
  - Internal approval UI, Slack interactive approvals, ticket-based approvals.

## Configuration Example
```yaml
machine:
  id: deal-hygiene-machine
  trigger_mode:
    realtime: true
    batch_cron: "*/30 * * * *"
  providers:
    context:
      - endgame_mcp
      - endgame_cli
      - salesforce_headless_360
    actions:
      - sfdc_writeback
      - slack_alert
      - task_create
    approvals:
      - approval_loop
  scoring:
    critical_threshold: 80
    high_threshold: 65
  policy:
    require_approval_for:
      - sfdc_update
      - close_date_change
      - stage_change
```

## Example Input/Output
Input event (simplified):
```json
{
  "event_type": "deal.updated",
  "source": "salesforce_headless_360",
  "subject": { "id": "006xx00000ABC123" },
  "attributes": { "deal_stage": "Proposal", "close_date_stale_days": 21 }
}
```

Output event (simplified):
```json
{
  "event_type": "deal.hygiene.remediated",
  "attributes": {
    "deal_score": 83,
    "recommended_play": "close_date_revalidation",
    "approval_status": "approved"
  }
}
```

## ChatGPT Workspace Agents Support
- ChatGPT + Slack surfaces:
  - Supports operator-facing interactions in ChatGPT workspace threads and Slack-connected surfaces for alert triage and remediation review.
- Cloud/background execution:
  - Maps machine stages to cloud-hosted agent runs with background continuation for delayed approvals or long remediation batches.
- Approval gates for sensitive actions:
  - Keeps `approval_loop` mandatory before high-impact mutations (for example SFDC stage/date updates) even when initiated from workspace agent surfaces.
- Enterprise governance/visibility expectations:
  - Assumes org-level auditability (trace IDs, proposed vs approved deltas, actor attribution), policy controls, and admin visibility across agent runs.

## Adapter Notes
- `n8n/`: Keep deterministic field mapping identical to contract names and ensure approval precedes write actions.
- `zapier/`: Keep deterministic field mapping identical to contract names and ensure approval precedes write actions.
- `tray/`: Keep deterministic field mapping identical to contract names and ensure approval precedes write actions.
- `make/`: Keep deterministic field mapping identical to contract names and ensure approval precedes write actions.
- `workato/`: Keep deterministic field mapping identical to contract names and ensure approval precedes write actions.
- `agentic/`: Use Smart Cogs as explicit staged tools with stable contracts.
- `claude-routines/`: Use routine steps as explicit staged tools with stable contracts.
- `claw-like/`: Use `HEARTBEAT.md` for schedule and liveness guarantees.

## Safety and Audit
- Never execute SFDC writes without `approval_loop` pass for high-impact changes.
- Emit trace IDs for every remediation decision.
- Persist proposed vs approved deltas for auditability.
