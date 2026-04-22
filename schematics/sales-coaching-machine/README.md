# Sales Coaching Machine

## Purpose
Convert post-call activity and pipeline movement into coaching actions that are directive-aligned, evidence-backed, and easy for managers/reps to execute.

## Where It Fits
Use this machine when you want consistent coaching quality at scale without forcing full manual review of every call.

## Primary KPIs
- Manager coaching actions completed per week.
- Win-rate lift on coached opportunities.
- Coaching recommendation adoption rate.

## Trigger Models
- Realtime trigger:
  - `call.completed`, `deal.stage_changed`, and engagement-risk events.
- Batch trigger:
  - Daily digest generation for managers and pipeline review workflows.

## Required Context Layers
- Endgame MCP + `endgame-cli`:
  - Interaction history, account context, user preferences, directives.
- Salesforce Headless 360:
  - Opportunity/account stage, ownership, and historical progression context.
- Conversation + enablement systems:
  - Gong/Zoom transcripts and Seismic/Highspot directive material.

## Integration Callouts
- Core context plane:
  - Endgame MCP/CLI for account graph, extracted facts, and cross-source retrieval.
- CRM/action layer:
  - Salesforce Headless 360 for stage movement, ownership context, and follow-up task writebacks.
- Call recorder inputs:
  - Gong/Zoom/Chorus for transcript, summary, and call-event triggers.
- Enablement alignment:
  - Seismic/Highspot for coaching rubric and approved messaging constraints.
- Research enrichment:
  - Exa/Perplexity/Parallel for external market or competitor context during coaching prep.

## End-to-End Flow (Canonical)
1. Ingest call/pipeline event as `gtm_event_v1`.
2. Pull related account and interaction context from Endgame tools.
3. Extract coaching opportunities and risk themes.
4. Score urgency/impact and route coaching priority.
5. Validate suggested coaching language against directives (`directive_alignment`).
6. Emit coaching task + summary payload for manager/rep execution.

## Smart Cogs Used
- `directive_alignment`:
  - Ensures coaching output aligns with SKO/enablement directives.
  - Example: flags recommendation that conflicts with approved discovery framework.
- `route_exec_alert`:
  - Routes urgent coaching scenarios (at-risk strategic deals) to leadership.
  - Example: sends executive visibility alert for late-stage multi-threading failure.
- Optional `deal_score_reasoner`:
  - Prioritizes coaching by opportunity risk/impact score.
  - Example: high-value, high-risk opp gets immediate manager escalation.

## Pluggable Interfaces
- Context providers (swap-in):
  - `endgame_mcp`, `endgame_cli`, `salesforce_headless_360`, `gong`, `zoom`, `seismic`, `highspot`.
- Action providers (swap-in):
  - CRM task creation, Slack coaching prompts, email digests, enablement workspace updates.
- Evaluation providers (swap-in):
  - rubric-based evaluator models, deterministic keyword checks, compliance gates.

## Configuration Example
```yaml
machine:
  id: sales-coaching-machine
  trigger_mode:
    realtime: true
    daily_digest_cron: "0 17 * * 1-5"
  providers:
    context:
      - endgame_mcp
      - endgame_cli
      - salesforce_headless_360
      - gong
      - seismic
    actions:
      - coaching_task_create
      - manager_digest_send
    evaluation:
      - directive_alignment
  coaching:
    min_signal_confidence: 0.70
    high_priority_score: 75
```

## Example Input/Output
Input event (simplified):
```json
{
  "event_type": "call.completed",
  "source": "gong",
  "subject": { "id": "call_34912" },
  "attributes": { "opportunity_id": "006xx00000ABC123" }
}
```

Output event (simplified):
```json
{
  "event_type": "coaching.recommendation.created",
  "attributes": {
    "alignment_status": "pass",
    "coaching_priority": "high",
    "recommended_action": "Run next call with MEDDPICC pain re-validation"
  }
}
```

## ChatGPT Workspace Agents Support
- ChatGPT + Slack surfaces:
  - Supports manager/rep coaching workflows in ChatGPT workspace threads and Slack-connected notifications/escalation surfaces.
- Cloud/background execution:
  - Supports cloud execution with background continuation for digest generation, delayed approvals, and multi-step coaching action pipelines.
- Approval gates for sensitive actions:
  - Preserves `approval_loop` before workflow-changing side effects (for example CRM task creation or high-risk outbound manager notifications).
- Enterprise governance/visibility expectations:
  - Assumes enterprise governance for policy checks, run/audit telemetry, actor attribution, and admin visibility across workspace agent operations.

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`:
  - Keep transcript-derived fields normalized to `gtm_event_v1` before scoring.
- `agentic/` and `claude-routines/`:
  - Isolate extraction, scoring, and alignment as explicit Smart Cog phases.
- `claw-like/`:
  - Use heartbeat for digest windows and stale-run alerting.

## Safety and Audit
- Keep transcript excerpts and recommendation rationale linked by trace ID.
- Route low-confidence or policy-sensitive coaching through human review.
- Preserve directive version IDs used in each recommendation.
