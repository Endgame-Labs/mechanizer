# Claw-like Adapter (consumption-renewal-intervention-machine)

Scheduled runtime mode where `HEARTBEAT.md` is the source of truth for cadence and liveness.

## Runtime
1. Run daily sweep.
2. Build intervention plans.
3. Notify Slack.
4. Optionally execute approved actions.
5. Emit heartbeat and terminal events.
