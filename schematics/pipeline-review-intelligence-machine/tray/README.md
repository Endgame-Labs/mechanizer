# Tray Adapter (pipeline-review-intelligence-machine)

Tray implementation blueprint for weekly pipeline review prep and manager summary generation.

## Reference Artifact
- `workflow.json`: callable-trigger workflow placeholder with shared-cog sequencing.

## Contract Notes
- Inbound payload must normalize to `gtm_event_v1`.
- Approval gate is mandatory before outbound summary delivery or mutation operations.
- Terminal events should emit `pipeline.review.prep.completed|deferred|failed`.
