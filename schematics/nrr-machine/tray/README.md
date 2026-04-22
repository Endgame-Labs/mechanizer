# Tray Adapter (nrr-machine)

This adapter implements `nrr-machine` as a Tray project with a callable entrypoint and a mandatory approval gate before side effects.

## Artifact
- `workflow.json`: importable blueprint-style artifact for the runtime path.
- Set environment-specific auth/config values at import time.

## Trigger Design
1. Callable Trigger (`nrr_event_ingest`) for upstream `gtm_event_v1` payloads.
2. Optional Scheduled Trigger (`0 */6 * * *`, `America/Los_Angeles`) for periodic cohort sweep.

Use a callable trigger because this machine is consumed as a reusable module from parent orchestrations.

## Contract and Approval Semantics
1. Validate required `gtm_event_v1` fields and normalize timestamps/trace.
2. Enrich from SFDC 360 + telemetry + billing + Endgame context.
3. Gate to `low_touch` / `no_touch` segments.
4. Score and assign play.
5. Draft outbound and mutation plan.
6. Run approval request (hard gate, required).
7. Only approved branch executes outbound + SFDC writes.
8. Rejected/timeout branch emits `nrr.play.blocked` and performs no writes.

Approval semantics are unchanged: no outbound or Salesforce mutation occurs before explicit approval.

## Error and Retry Pattern
- Default mode: Tray automatic retry/backoff for transient step failures.
- For critical write steps, enable connector-level manual error handling with explicit failure paths.
- For blocking failures, route to dead-letter event + alerting workflow payload including `workflow_uuid`, `step_name`, and `step_log_url`.
- Keep idempotency key pinned to `event_id` on side-effect steps.

## SDLC and Promotion Pattern (Tray Projects)
1. Build/test in dev workspace project with sandbox credentials.
2. Save a project version at release-candidate milestone.
3. Export project JSON and import to stage/prod project.
4. Resolve auth mapping, service/connector mapping, and config values during import.
5. Run pre-import preview checks before final import.
6. First prod import is manual to map production auth correctly; later promotions can be automated via Projects/Solutions APIs when mappings are stable.

Suggested release metadata per version:
- machine version + project version number
- breaking/non-breaking notes
- auth scope changes
- rollout date + owner

## Callable Safety
- Do not disable callable workflows directly.
- If temporary shutdown is required, place `Terminate` before connector side effects.

## Observability
Track per run:
- `run_id`, `event_id`, `trace.trace_id`, `subject.id`
- `segment`, `score`, `play_type`, `reason_codes`
- `approval_status`, `approval_wait_ms`
- `write_attempts`, `write_success_count`, `write_failure_count`
- `step_log_url` for alert triage
