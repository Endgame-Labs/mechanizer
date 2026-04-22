# Tray Adapter (renewal-risk-monitoring-machine)

## Artifact
- `workflow.json`

## Trigger Design
- Scheduled trigger at 07:00 PT for daily renewal-near account sweep.
- Optional callable trigger for event-driven runs.

## Contract Semantics
1. Validate `gtm_event_v1`.
2. Build recommended play from risk signals.
3. Send CSM Slack alert.
4. Route high-severity exec alert.
5. Execute only approved optional actions.
