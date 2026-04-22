# Meeting Prep Brief Machine

## Purpose
Generate and deliver a concise pre-meeting account brief to Slack and inbox with current account context, risk flags, and talk-track guidance.

## Where It Fits
Use this machine when teams need consistent prep quality for customer calls and executive meetings without manual research for every event.

## Primary KPIs
- Brief delivery before meeting start.
- Prep time saved per meeting.
- Brief consumption and follow-through rate.

## Trigger Models
- Realtime trigger:
  - `meeting.scheduled`, `account.exec_meeting_booked`, `opportunity.stage_changed`.
- Batch trigger:
  - Scheduled near-term meeting sweep to fill missing briefs and refresh stale context.

## Required Context Layers
- Calendar systems:
  - Google/Outlook calendar metadata for attendees, meeting type, and start window.
- Endgame MCP + `endgame-cli`:
  - Recent interactions, directive context, and account timeline.
- CRM + product systems:
  - Open opportunities, renewal windows, usage trend, support signals.
- Optional enrichment:
  - Public company updates and funding/product-change context.

## End-to-End Flow (Canonical)
1. Ingest meeting trigger as `gtm_event_v1`.
2. Enrich account and meeting context (`enrich_account_health`).
3. Score meeting priority and prep depth (`deal_score_reasoner`).
4. Validate guidance against directives (`directive_alignment`).
5. Compose brief sections (`compose_outreach_message`).
6. Route high-severity items (`route_exec_alert`) and run `approval_loop`.
7. Deliver approved brief to Slack/inbox and emit completion event.

## Smart Cogs Used
- `enrich_account_health`: build account risk/context features.
- `deal_score_reasoner`: rank meeting prep depth and urgency.
- `directive_alignment`: enforce approved messaging and policy.
- `compose_outreach_message`: generate structured brief narrative and bullets.
- `route_exec_alert`: escalate strategic-risk meetings.
- `approval_loop`: mandatory gate before brief delivery for high-severity meetings.

## Example Input/Output
Input event (simplified):
```json
{
  "event_type": "meeting.scheduled",
  "source": "google_calendar",
  "subject": { "entity_id": "acct_001" },
  "attributes": { "meeting_start_at": "2026-04-23T17:00:00Z", "owner_email": "ae@example.com" }
}
```

Output event (simplified):
```json
{
  "event_type": "meeting.prep_brief.delivered",
  "attributes": {
    "priority_band": "high",
    "delivery_channels": ["slack", "email"],
    "approval_status": "approved"
  }
}
```

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`:
  - Keep approval immediately before Slack/email delivery nodes.
- `agentic/` and `claude-routines/`:
  - Keep enrichment, scoring, alignment, composition, and approval as explicit phases.
- `claw-like/`:
  - Use heartbeat-driven meeting-window sweeps and stale-run alerts.

## ChatGPT Workspace Agents Support
- Surfaces: supports ChatGPT workspace execution with Slack delivery and action follow-up handoff.
- Execution: supports cloud/background runs for meeting-window sweeps and regenerate requests.
- Sensitive actions: requires approval before high-severity or executive outbound brief delivery.
- Governance/visibility: keeps event lineage, approval outcomes, and delivery status observable in emitted events.
