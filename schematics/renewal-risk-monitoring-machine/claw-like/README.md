# Claw-like Adapter (renewal-risk-monitoring-machine)

Scheduled runtime mode where `HEARTBEAT.md` is the source of truth for cadence and liveness.

## Runtime
1. Run daily renewal-near risk sweep.
2. Build recommended plays for at-risk accounts.
3. Alert owning CSM in Slack.
4. Route high-severity risks to exec channel.
5. Optionally execute approved actions.
6. Emit heartbeat and terminal events.
