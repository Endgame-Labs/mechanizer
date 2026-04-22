# Zapier Adapter (renewal-risk-monitoring-machine)

## Artifact
- `zap.template.json`

## Trigger Paths
- Schedule by Zapier: daily 07:00 local workspace timezone.
- Optional webhook trigger for `gtm_event_v1` payloads.

## Core Steps
1. Validate contract.
2. Enrich and score renewal risk.
3. Compose recommended play.
4. Post CSM Slack alert (required).
5. Route high-severity exec alert.
6. Branch for approval-gated optional actions.
