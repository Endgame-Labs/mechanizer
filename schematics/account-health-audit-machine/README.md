# Account Health Audit Machine

## Purpose
Run a deterministic scheduled account health audit that fuses warehouse metrics, CRM state, and conversation intelligence into a narrative summary with a prioritized execution roadmap.

## Where It Fits
Use this machine when teams need consistent, recurring account health analysis with stable contract outputs and cross-platform adapter parity.

## Primary KPIs
- Scheduled audit completion rate.
- Median time-to-insight from snapshot to published narrative.
- Roadmap action adoption rate.

## Trigger Models
- Scheduled trigger:
  - Weekday audit run (`0 6 * * 1-5`) for stable reporting cadence.
- Event trigger:
  - `audit.run_requested`, `audit.snapshot_ready` for ad hoc or dependency-driven execution.

## Required Context Layers
- Warehouse/BI:
  - Product usage, support trends, billing utilization, health deltas.
- CRM:
  - Account hierarchy, owner state, renewal timelines, opportunity risk context.
- Conversation systems:
  - Call summaries/transcripts and sentiment or risk themes.
- Endgame MCP + `endgame-cli`:
  - Unified context retrieval, directives, and traceable enrichment.

## Integration Callouts
- Core context plane:
  - Endgame MCP/CLI for retrieval, directives, and trace continuity.
- Data systems:
  - Warehouse/BI feeds plus Salesforce Headless 360/CRM snapshots.
- Conversation intelligence:
  - Gong/Zoom/Chorus signals for qualitative narrative context.

## End-to-End Flow (Canonical)
1. Ingest schedule/event trigger as `gtm_event_v1`.
2. Normalize and merge warehouse + CRM + conversation snapshots.
3. Enrich health factors (`enrich_account_health`).
4. Score risk and impact (`deal_score_reasoner`).
5. Validate recommendations against directives (`directive_alignment`).
6. Route high-severity escalations (`route_exec_alert`).
7. Build deterministic narrative summary and prioritized roadmap.
8. Emit `account.health.audit.completed` as `gtm_event_v1`.

## Smart Cogs Used
- `enrich_account_health`:
  - Produces normalized health features and trend flags.
- `deal_score_reasoner`:
  - Calculates score bands and priority ordering.
- `directive_alignment`:
  - Ensures roadmap language follows policy/directives.
- `route_exec_alert`:
  - Escalates critical findings to defined owners/channels.

## Pluggable Interfaces
- Context providers (swap-in):
  - `warehouse_bi`, `salesforce_headless_360`, `salesforce`, `hubspot`, `gong`, `zoom`, `endgame_mcp`, `endgame_cli`.
- Action providers (swap-in):
  - Narrative delivery channels, CRM task systems, ticket/project managers.
- Evaluation providers (swap-in):
  - Deterministic scoring checkers and human QA review pipelines.

## Configuration Example
```yaml
machine:
  id: account-health-audit-machine
  trigger_mode:
    schedule_cron: "0 6 * * 1-5"
    timezone: "America/Los_Angeles"
  providers:
    context:
      - warehouse_bi
      - salesforce_headless_360
      - gong
      - endgame_mcp
    actions:
      - account_health_audit_publish
      - roadmap_task_upsert
  scoring:
    critical_threshold: 80
    high_threshold: 65
```

## Example Input/Output
Input event (simplified):
```json
{
  "schema_version": "gtm_event_v1",
  "event_type": "audit.snapshot_ready",
  "source": "warehouse_bi",
  "subject": { "entity_type": "account", "entity_id": "001xx00000ACCT42" },
  "attributes": { "snapshot_id": "snap_2026_04_22_0600" }
}
```

Output event (simplified):
```json
{
  "schema_version": "gtm_event_v1",
  "event_type": "account.health.audit.completed",
  "attributes": {
    "health_score": 74,
    "risk_band": "high",
    "narrative_summary": "Adoption is stable but exec engagement and multithreading declined over 21 days.",
    "roadmap": [
      { "priority": 1, "action": "Re-establish executive thread within 7 days" },
      { "priority": 2, "action": "Launch usage recovery play for inactive teams" }
    ]
  }
}
```

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`:
  - Keep deterministic mapping and priority ordering stable across adapters.
- `agentic/` and `claude-routines/`:
  - Use the same cog order and enforce contract checks pre/post reasoning.
- `claw-like/`:
  - Drive scheduling and liveness from `HEARTBEAT.md`.

## ChatGPT Workspace Agents Support
- ChatGPT and Slack surfaces:
  - This machine can be exposed as a Workspace Agent in ChatGPT and Slack while preserving the canonical audit pipeline and `gtm_event_v1` contract boundaries.
- Cloud and background runs:
  - Scheduled weekday audits and ad hoc reruns can execute in cloud/background mode with deterministic completion emits.
- Approval gates for sensitive actions:
  - Read-only audit generation can auto-run; any downstream mutation (CRM/tasks/outbound) remains approval-gated per `approval_loop` policy.
- Governance and visibility:
  - Workspace governance should retain run evidence, rationale artifacts, and full lineage (`event_id`, `trace`) for audit replay and compliance review.

## Safety and Audit
- Preserve `event_id` and `trace.trace_id` through all phases.
- Emit deterministic rationale for each roadmap priority decision.
- Keep source evidence references in output attributes for auditability.
