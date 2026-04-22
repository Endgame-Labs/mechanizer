# Make Adapter (renewal-risk-monitoring-machine)

## Artifact
- `scenario.json`

## Trigger Paths
- Daily scheduled run for renewal-near risk sweep.
- Optional webhook ingestion path.

## Flow
1. Parse and validate event contract.
2. Score risk and build recommended play.
3. Notify CSM in Slack.
4. Route high-severity exec alert.
5. Route optional actions through approval.
6. Emit terminal event.
