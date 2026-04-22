# Consumption Renewal Intervention Machine

## Purpose
Detect renewals with under-consumption risk on a daily cadence, generate an intervention plan, notify Slack, and optionally execute approved downstream actions.

## Where It Fits
Use this machine when renewal cohorts are too large for manual daily inspection and teams need reliable intervention planning with contract-safe automation.

## Trigger Models
- Daily schedule: `0 7 * * *` (`America/Los_Angeles`)
- Event triggers: `renewal.window_opened`, `renewal.consumption_under_target_detected`

## End-to-End Flow
1. Ingest or synthesize candidate renewal events (`gtm_event_v1`).
2. Enrich account + renewal context (`enrich_account_health`).
3. Score intervention urgency (`deal_score_reasoner`).
4. Validate against policy/directives (`directive_alignment`).
5. Build intervention plan + draft messaging (`compose_outreach_message`).
6. Notify Slack with plan summary and action links.
7. Run approval loop for optional downstream actions.
8. Execute approved optional actions and emit terminal event.

## Always-On vs Optional Actions
- Always-on: `slack_notify`
- Optional (approval-gated): `renewal_plan_update`, `csm_task_create`, `outbound_email_send`

## Example Input
```json
{
  "event_type": "renewal.consumption_under_target_detected",
  "source": "daily_sweep",
  "subject": { "id": "001xx00000ACCT99" },
  "attributes": {
    "renewal_date": "2026-06-30",
    "consumption_pct": 52,
    "threshold_pct": 65
  }
}
```

## Example Output
```json
{
  "event_type": "cri.play.executed",
  "attributes": {
    "intervention_score": 84,
    "recommended_play": "renewal_rescue",
    "slack_notification_status": "sent",
    "optional_actions_executed": ["renewal_plan_update"]
  }
}
```

## ChatGPT Workspace Agents Support
- Surfaces: supports ChatGPT workspace execution with Slack-facing notifications and action prompts.
- Execution: supports cloud/background runs for daily sweeps and delayed approval resumes.
- Sensitive actions: keeps renewal mutations and outbound actions behind explicit approval checkpoints.
- Governance/visibility: preserves run traceability through event IDs, approval state, and emitted terminal events.
