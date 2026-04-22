# Tray Adapter (consumption-renewal-intervention-machine)

## Artifact
- `workflow.placeholder.json`

## Trigger Design
- Scheduled trigger at 07:00 PT for daily cohort sweep.
- Optional callable trigger for event-driven runs.

## Contract Semantics
1. Validate `gtm_event_v1`.
2. Build intervention plan for under-consuming renewals.
3. Send Slack summary.
4. Execute only approved optional actions.
