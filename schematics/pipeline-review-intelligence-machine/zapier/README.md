# Zapier Adapter (pipeline-review-intelligence-machine)

## Reference Artifact
- `zap.template.json`: template step contract for pipeline-review prep execution.

## Trigger Mapping
- `Webhooks by Zapier -> Catch Hook` or scheduled trigger.
- Normalize inbound payload to `gtm_event_v1`.

## Required Smart-Cog Sequence
1. `enrich_account_health`
2. `deal_score_reasoner`
3. `directive_alignment`
4. `compose_outreach_message`
5. `route_exec_alert`
6. `approval_loop`

## Approval Contract
- Approval must run immediately before manager summary sends and high-impact mutations.
- Non-approved outcomes emit `pipeline.review.prep.deferred` and stop side effects.
