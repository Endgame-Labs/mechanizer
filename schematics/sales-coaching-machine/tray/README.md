# Tray Adapter (sales-coaching-machine)

Tray runtime for `sales-coaching-machine` using callable ingestion, directive alignment branching, and deterministic output emission.

## Artifact
- `workflow.json`: callable workflow blueprint with alignment branch and dead-letter path.

## Runtime Flow
1. Callable trigger accepts call event payload.
2. Guard on `type == call.completed`.
3. Normalize to canonical `gtm_event_v1` structure.
4. Fetch context from Endgame.
5. Run directive alignment check.
6. Branch:
- `pass`: create Salesforce task + manager notification.
- `fail`: escalation route (ticket/Slack).
7. Emit normalized output event.

## Contract Mapping
- `call.id` -> `subject.id`
- `call.account_id` -> `attributes.account_id`
- `call.opportunity_id` -> `attributes.opportunity_id`
- Tray run id -> `trace.run_id`
- alignment output -> `attributes.alignment_status`

## Error Handling and Retries
- Keep HTTP connector timeouts explicit (20s baseline).
- Use Tray automatic retry/backoff for transient provider errors.
- For branch side effects, use connector-level manual error path to dead-letter/alerting workflow.
- Include `step_log_url` in alerts for quick replay/debug.

## Callable Workflow Guidance
- Use `Call workflow` with `Fire and wait for response` when parent workflow needs structured response data.
- Define trigger input schema and callable response output schema to enforce strict data structure.
- If callable workflow must be paused, use a leading `Terminate` step instead of disabling.

## SDLC and Promotion
1. Build/test in dev project.
2. Save project versions at tested milestones.
3. Export/import project JSON for stage/prod promotion.
4. Resolve auth mappings and config values during import.
5. Run pre-import preview checks prior to commit.
6. For repeatable releases, automate import/version/publish steps through Tray Projects/Solutions APIs.
