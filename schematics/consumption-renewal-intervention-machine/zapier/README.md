# Zapier Adapter (consumption-renewal-intervention-machine)

## Artifact
- `zap.template.json`

## Trigger Paths
- Schedule by Zapier: daily 07:00 local workspace timezone.
- Optional webhook trigger for `gtm_event_v1` payloads.

## Core Steps
1. Validate contract.
2. Enrich and score intervention.
3. Compose intervention plan.
4. Post Slack summary (required).
5. Branch for approval-gated optional actions.
