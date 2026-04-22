# Claw-like Adapter (stage-change-deal-review-machine)

`claw-like` runs heartbeat-driven stage-change review in cron-native environments.

## Required Files
- `HEARTBEAT.md`: liveness, owner, and schedule contract.

## Runtime Model
1. Read schedule from heartbeat contract.
2. Enforce one in-flight run per machine.
3. Run canonical stages:
- collect stage-progressed opportunities
- validate `gtm_event_v1` envelopes
- run qualification/risk/missing-field review
- route through `approval_loop`
- apply approved writebacks or post Slack findings
4. Emit heartbeat after successful terminal event emission.

## Safety Rules
- No CRM writebacks before approval status is `approved`.
- Denied/expired approvals emit findings-only outcomes.
- Safe mode blocks side effects and emits machine-safe-mode event.
