# Tier-3 Account Coverage Machine

![tier-3-account-coverage-machine Diagram](./diagram.svg)

## Purpose
Automate long-tail account coverage for low-touch/no-touch segments by combining deterministic signal monitoring, smart-cog scoring, approval-gated outreach, and churn/expansion trigger surfacing.

## Where It Fits
Use this machine when account volume exceeds manual CSM capacity and teams need consistent monitoring plus lightweight outreach across tier-3 books.

## Primary KPIs
- Tier-3 account coverage rate without human intervention.
- Signal-to-action lead time for churn and expansion triggers.
- Outreach approval-to-execution rate.
- Churn risk intervention coverage.

## Trigger Models
- Realtime trigger:
  - `account.health_changed`, `usage.declined`, `renewal.window_opened`, `intent.signal_detected`.
- Batch trigger:
  - Scheduled cohort sweep every 6 hours for stale coverage and newly eligible accounts.

## Required Context Layers
- Endgame MCP + `endgame-cli`:
  - Directive retrieval, account timeline, prior engagement context.
- Salesforce Headless 360:
  - Account health, renewal windows, owner metadata, notes/writeback.
- Product + billing + support systems:
  - Adoption trends, contract pressure, ticket escalation signals.

## End-to-End Flow (Canonical)
1. Ingest canonical `gtm_event_v1` signal.
2. Enrich account context via `enrich_account_health`.
3. Score churn/expansion posture via `deal_score_reasoner`.
4. Align actions to policy/directives via `directive_alignment`.
5. Draft outreach via `compose_outreach_message`.
6. Escalate high-impact cases via `route_exec_alert`.
7. Require review for outbound/CRM side effects via `approval_loop`.
8. Execute approved actions and emit `gtm_event_v1` result.

## Smart Cogs Used
- `enrich_account_health`:
  - Produces normalized feature set for tier-3 monitoring.
- `deal_score_reasoner`:
  - Outputs churn/expansion score, confidence, and play type.
- `directive_alignment`:
  - Ensures compliant language and approved action scope.
- `compose_outreach_message`:
  - Generates low-touch outreach draft by persona/segment.
- `route_exec_alert`:
  - Escalates strategic anomalies discovered in long-tail cohorts.
- `approval_loop`:
  - Mandatory gate for outbound and mutation side effects.

## Example Input/Output
Input event (simplified):
```json
{
  "event_type": "usage.declined",
  "source": "product_telemetry",
  "subject": { "id": "001xx00000TIER3A" },
  "attributes": { "usage_drop_pct": 31, "segment": "low_touch" }
}
```

Output event (simplified):
```json
{
  "event_type": "tier3.coverage.executed",
  "attributes": {
    "coverage_status": "actioned",
    "play": "churn_prevent_nudge",
    "approval_status": "approved"
  }
}
```

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`, `workato/`:
  - Keep approval check immediately before outbound and CRM writes.
- `agentic/` and `claude-routines/`:
  - Keep stage boundaries explicit and contract-preserving.
- `claw-like/`:
  - Use heartbeat cadence for low-touch cohort sweeps and stale detection.

## ChatGPT Workspace Agents Support
- ChatGPT and Slack surfaces:
  - This machine can run as a Workspace Agent surfaced in ChatGPT and Slack while preserving canonical stage boundaries and `gtm_event_v1` ingress/egress.
- Cloud and background runs:
  - Cohort sweeps and delayed approval resumes can execute as cloud/background runs; terminal emits remain idempotent and replay-safe.
- Approval gates for sensitive actions:
  - Outbound sends and CRM mutations stay behind `approval_loop`; Workspace Agent execution must not bypass contract-defined HITL checkpoints.
- Governance and visibility:
  - Keep run logs, approval decisions, trace lineage, and tool-call evidence visible to workspace governance/audit views using the existing `event_id` and `trace` contracts.

## Safety and Audit
- No outbound or CRM mutation before explicit approval.
- Persist score reasons, decision thresholds, and directive IDs.
- Emit trace lineage for every terminal result (`executed`, `blocked`, `failed`).
