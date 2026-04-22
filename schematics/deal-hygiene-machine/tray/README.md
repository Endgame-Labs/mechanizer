# Tray Adapter (deal-hygiene-machine)

Tray implementation of `deal-hygiene-machine` using callable ingestion, policy/approval gating, and controlled Salesforce writeback.

## Reference Artifact
- `workflow.json`: runtime blueprint including idempotency, approval branch, and SDLC metadata.

## Trigger Mapping
- Trigger type: Callable Trigger receiving canonical `gtm_event_v1`.
- Strict input validation (required keys and type checks) before cog execution.
- Reject invalid payloads into dead-letter path with full trace.

## Transform and Cog Stages
1. `normalize_validate`
2. `idempotency_check`
3. `enrich_account_health`
4. `deal_score_reasoner`
5. `directive_alignment`
6. `route_exec_alert`
7. `approval_loop` (mandatory before writes)
8. Branch to approved/deferred
9. Approved branch performs SFDC update and emits `deal.hygiene.remediated`
10. Deferred branch emits `deal.hygiene.deferred`

## Approval Contract
- Approval is the last gate before write operations.
- Rejected/expired approvals route to deferred event with `attributes.approval_status`.
- No Salesforce write occurs on deferred branch.

## Error and Retry Path
- Transient connector failures: Tray automatic retry/backoff.
- Deterministic policy failures: no retries, route to deferred/dead-letter.
- Connector-level manual error handling enabled for high-risk write steps.
- Alerting workflow receives `step_log_url` for one-click debug/replay.

## SDLC / Environment Promotion
1. Dev project: implement and test with sandbox auth.
2. Save annotated project versions at stable checkpoints.
3. Export version JSON and import into stage/prod project.
4. Complete authentication mapping and dependency mapping at import.
5. Resolve project config values per environment.
6. Use pre-import checks/previews before import commit.
7. Manual first production import; subsequent imports can be automated with Tray APIs if auth dependencies are unchanged.

## Versioning Notes
- Keep source and destination version numbers aligned where possible.
- Record migration notes for any contract-impacting change.
- Maintain promotion log with version, approver, and deployment timestamp.
