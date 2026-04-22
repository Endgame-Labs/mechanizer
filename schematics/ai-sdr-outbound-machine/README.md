# AI SDR Outbound Machine

## Purpose
Automate outbound prospect research, generate personalized multi-step sequence drafts, and route qualified inbound responses to the right human owner with full contract traceability.

## Where It Fits
Use this machine when SDR teams need higher outbound throughput without sacrificing personalization quality, directive compliance, or response qualification rigor.

## Primary KPIs
- Qualified meetings booked from machine-generated sequences.
- Positive response rate on personalized outbound.
- Time-to-first-touch for new qualified target accounts.

## Trigger Models
- Realtime trigger:
  - `prospect.research_requested`, `account.intent_detected`, `response.received`.
- Batch trigger:
  - Cohort sweeps for territory/account lists and stale sequence refresh.

## Required Context Layers
- Endgame MCP + `endgame-cli`:
  - Prior interactions, account context, and directive retrieval.
- CRM + engagement systems:
  - Salesforce Headless 360, HubSpot, Outreach/Salesloft style sequence status.
- Enrichment + intent:
  - Apollo/Clearbit/LinkedIn and intent-provider signals.

## End-to-End Flow (Canonical)
1. Ingest trigger as `gtm_event_v1`.
2. Enrich account and persona context (`enrich_account_health`).
3. Score fit/intent/priority (`deal_score_reasoner`).
4. Validate claims and policy constraints (`directive_alignment`).
5. Draft personalized sequence (`compose_outreach_message`).
6. Escalate strategic/high-risk cases (`route_exec_alert`).
7. Gate side effects via `approval_loop`.
8. Execute approved writes and emit machine output event.

## Smart Cogs Used
- `enrich_account_health`:
  - Consolidates account/persona data used for personalization.
- `deal_score_reasoner`:
  - Classifies outreach priority and qualification tier.
- `directive_alignment`:
  - Blocks unsupported claims and off-policy messaging.
- `compose_outreach_message`:
  - Produces sequence steps by persona and trigger context.
- `route_exec_alert`:
  - Escalates strategic account responses or urgent risks.
- `approval_loop`:
  - Required before sequence launch and CRM mutation.

## Example Input/Output
Input event (simplified):
```json
{
  "event_type": "prospect.research_requested",
  "source": "salesforce_headless_360",
  "subject": { "id": "lead_8721" },
  "attributes": { "account_id": "001xx00000ABCD9", "persona": "vp_marketing" }
}
```

Output event (simplified):
```json
{
  "event_type": "sdr.sequence.ready",
  "attributes": {
    "qualification_tier": "high",
    "sequence_id": "seq_42a1",
    "approval_status": "approved",
    "response_route": "sdr_queue_west"
  }
}
```

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`:
  - Normalize all inbound payloads to `gtm_event_v1` first.
- `agentic/` and `claude-routines/`:
  - Keep enrichment, scoring, alignment, drafting, and approval as explicit stages.
- `claw-like/`:
  - Use heartbeat schedule for refresh runs and stale-run alerting.
