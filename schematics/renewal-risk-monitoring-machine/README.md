# Renewal Risk Monitoring Machine

## Purpose
Identify renewal-near accounts with elevated risk signals, generate recommended plays, alert CSM owners, and optionally execute approved downstream actions.

## Where It Fits
Use this machine when the renewal book is too large for manual review and CSMs need daily, prioritized risk alerts with actionable next plays.

## Trigger Models
- Daily schedule: `0 7 * * *` (`America/Los_Angeles`)
- Event triggers: `renewal.window_opened`, `account.risk_signal.detected`

## End-to-End Flow
1. Ingest or synthesize candidate renewal-risk events (`gtm_event_v1`).
2. Enrich account + renewal context (`enrich_account_health`).
3. Score risk and classify urgency (`deal_score_reasoner`).
4. Validate against policy and playbook constraints (`directive_alignment`).
5. Build recommended play + CSM-ready message (`compose_outreach_message`).
6. Send required CSM alert (Slack).
7. Route high-severity risks for exec visibility (`route_exec_alert`).
8. Run approval loop for optional downstream actions and emit terminal event.

## Always-On vs Optional Actions
- Always-on: `slack_notify`
- Conditional always-on: `exec_alert_route` for high-severity risk only
- Optional (approval-gated): `csm_task_create`, `playbook_recommendation_upsert`

## Example Input
```json
{
  "event_type": "account.risk_signal.detected",
  "source": "daily_renewal_risk_sweep",
  "subject": { "id": "001xx00000RISK77" },
  "attributes": {
    "renewal_date": "2026-07-15",
    "days_to_renewal": 84,
    "risk_signals": ["usage_decline", "open_p1_support_case"],
    "health_score": 58
  }
}
```

## Example Output
```json
{
  "event_type": "renewal.risk.monitoring.completed",
  "attributes": {
    "risk_score": 87,
    "risk_tier": "high",
    "recommended_play": "exec_alignment_and_rescue_plan",
    "slack_notification_status": "sent",
    "optional_actions_executed": ["csm_task_create"]
  }
}
```
