# Claw-like Adapter (meeting-prep-brief-machine)

`claw-like` is the scheduled runtime for `meeting-prep-brief-machine` when no visual flow orchestrator is used.
`HEARTBEAT.md` is the contract source for cadence, liveness, stale detection, and escalation.

## Runtime Model
1. Parse heartbeat schedule and timezone.
2. Enforce single active run lock.
3. Discover near-term meetings in execution window.
4. Normalize events to `gtm_event_v1`.
5. Enrich, score, compose, and policy-check briefs.
6. Run approval gate for high-severity deliveries.
7. Deliver approved briefs and emit terminal events.
8. Emit heartbeat only after full successful completion.

## Safe-Mode Behavior
- Enter safe mode on stale transitions or approval subsystem outage.
- In safe mode:
- continue enrichment and draft generation
- suppress Slack/email deliveries
- emit `meeting.prep_brief.safe_mode`

## Retry Defaults
- Scheduler/bootstrap failures: 2 retries.
- Context and composition transients: 3 retries.
- Delivery transports: 2 retries.
- Non-retryable: validation failures, policy denies, approval timeout.
