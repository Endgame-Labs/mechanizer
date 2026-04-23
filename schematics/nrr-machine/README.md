# NRR Machine

![nrr-machine Diagram](./diagram.svg)

## Purpose
Increase net revenue retention in low-touch/no-touch segments by combining deterministic health signals with agentic play selection, messaging, and approval-gated execution.

## Where It Fits
Use this machine for scaled retention + expansion motion where human teams cannot manually inspect every account weekly.

## Primary KPIs
- NRR improvement against baseline.
- At-risk account intervention lead time.
- Expansion play conversion rate.

## Trigger Models
- Realtime trigger:
  - `account.health_changed`, `usage.declined`, `renewal.window_opened`.
- Batch trigger:
  - Scheduled segment sweeps for drift detection, scoring refresh, and queued outreach.

## Required Context Layers
- Endgame MCP + `endgame-cli`:
  - Account history, Slack/notes context, directive retrieval, people and interaction enrichment.
- Salesforce Headless 360:
  - Renewal/opportunity/account state and writeback actions.
- Billing + telemetry systems:
  - Usage/adoption signals, commercial health indicators, contract timelines.
- Optional external context:
  - Exa-style web/company signals for expansion or risk enrichment.

## Integration Callouts
- Core context plane:
  - Endgame MCP/CLI for context graph, extracted facts, and directive-backed action planning.
- CRM/action layer:
  - Salesforce Headless 360 for renewal state, opportunity updates, and approved writebacks.
- Call recorder inputs:
  - Gong/Zoom/Chorus to incorporate conversation risk or champion-signal changes.
- Enablement alignment:
  - Seismic/Highspot for approved renewal and expansion messaging frameworks.
- Research enrichment:
  - Exa/Perplexity/Parallel for public signals (hiring, launches, funding, market shifts).

## End-to-End Flow (Canonical)
1. Ingest signal as `gtm_event_v1`.
2. Enrich account health (`enrich_account_health`).
3. Produce score and recommended play (`deal_score_reasoner`).
4. Validate messaging and actions against directives (`directive_alignment`).
5. Compose outbound message draft (`compose_outreach_message`).
6. Route high-impact actions through `approval_loop`.
7. Execute approved outreach and SFDC updates; emit completion event.

## Smart Cogs Used
- `enrich_account_health`:
  - Builds deterministic health features from usage + CRM + billing context.
  - Example: flags seat under-utilization plus declining meeting volume.
- `deal_score_reasoner`:
  - Selects risk/expansion score band and play type.
  - Example: `monitor` -> proactive QBR, `critical` -> retention rescue path.
- `directive_alignment`:
  - Ensures outbound strategy follows approved messaging/policy.
  - Example: blocks discount language that violates renewal policy.
- `compose_outreach_message`:
  - Drafts segment/persona-aware outreach.
  - Example: VP Sales gets ROI recap + adoption benchmark narrative.
- `approval_loop`:
  - Mandatory gate for outbound email or SFDC commercial-impact updates.
  - Example: approval required before sequence send and renewal-field modifications.
- `route_exec_alert`:
  - Escalates top-risk strategic accounts.

## Pluggable Interfaces
- Context providers (swap-in):
  - `endgame_mcp`, `endgame_cli`, `salesforce_headless_360`, `salesforce`, `gainsight`, `stripe`, warehouse/BI.
- Action providers (swap-in):
  - Email sequencers, CRM writebacks, CSM task systems, Slack routing.
- Approval providers (swap-in):
  - Human review queues, Slack approvals, ticket workflows.
- Enrichment providers (swap-in):
  - Exa/public research, internal product telemetry pipelines.

## Configuration Example
```yaml
machine:
  id: nrr-machine
  segment:
    include: [low_touch, no_touch]
    exclude: [strategic_enterprise]
  trigger_mode:
    realtime: true
    batch_cron: "0 */6 * * *"
  providers:
    context:
      - endgame_mcp
      - endgame_cli
      - salesforce_headless_360
      - stripe
    enrichment:
      - product_telemetry
      - exa
    actions:
      - outbound_email_send
      - renewal_plan_update
      - csm_task_create
    approvals:
      - approval_loop
  policy:
    require_approval_for:
      - outbound_email_send
      - commercial_field_update
  scoring:
    critical_threshold: 78
    expansion_threshold: 72
```

## Example Input/Output
Input event (simplified):
```json
{
  "event_type": "renewal.window_opened",
  "source": "salesforce_headless_360",
  "subject": { "id": "001xx00000ACCT99" },
  "attributes": { "arr": 92000, "days_to_renewal": 75 }
}
```

Output event (simplified):
```json
{
  "event_type": "nrr.play.executed",
  "attributes": {
    "deal_score": 81,
    "recommended_play": "retention_rescue",
    "message_channel": "email",
    "approval_status": "approved"
  }
}
```

## ChatGPT Workspace Agents Support
- ChatGPT + Slack surfaces:
  - Supports retention/expansion operator workflows in ChatGPT workspace threads and Slack-connected approval/notification surfaces.
- Cloud/background execution:
  - Supports cloud-hosted execution with background continuation for queued cohort sweeps, delayed approvals, and long-running play orchestration.
- Approval gates for sensitive actions:
  - Requires `approval_loop` for outbound sends and commercial-impact CRM updates, including actions triggered from workspace agent sessions.
- Enterprise governance/visibility expectations:
  - Expects enterprise controls for policy enforcement, run-level audit trails, trace lineage, and admin visibility into side-effecting actions.

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`:
  - Keep approval node immediately before outbound and CRM write actions.
- `agentic/` and `claude-routines/`:
  - Keep scoring, alignment, message composition, and approval as explicit Smart Cog phases.
- `claw-like/`:
  - Use heartbeat schedule for cohort sweeps and stale-run alerts.

## Safety and Audit
- Outbound and commercial-impact writes must be approval-gated.
- Persist score reasons and directive IDs used in decisioning.
- Emit full trace lineage for every executed play.
