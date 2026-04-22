# Tray Adapter (stage-change-deal-review-machine)

Tray implementation of stage-change review with strict idempotency and approval-gated writebacks.

## Reference Artifact
- `workflow.placeholder.json`: starter blueprint with branch contracts.

## Trigger Mapping
- Callable trigger receives canonical `gtm_event_v1` stage-change events.
- Validate required keys before cog execution.

## Stages
1. `normalize_validate`
2. `idempotency_check`
3. `enrich_account_health`
4. `deal_score_reasoner`
5. `directive_alignment`
6. `route_exec_alert`
7. `approval_loop`
8. Approved branch: CRM writeback + writeback event
9. Findings branch: Slack findings + findings event

## Error and Retry Path
- Transient connector failures: automatic retries/backoff.
- Validation/policy failures: terminal findings-only or failed-validation output.
