# Routine Spec (deal-hygiene-machine)

## Schema Bindings
- Input contract: `gtm_event_v1`
- Output contract: `gtm_event_v1`
- Machine objective: detect and remediate deal hygiene drift with approval-gated writes.

## Claude Runtime Assumptions (Apr 22, 2026)
- Runs in Anthropic-managed Claude Code routine sessions.
- No in-run permission prompts; policy gating must be encoded in the workflow.
- API-triggered routine input `text` is freeform and not JSON-parsed by the routine transport.

## Phases

### Phase A: Validate Event Envelope
- Tools: `validate_gtm_event`
- Checks:
  - `schema_version == gtm_event_v1`
  - Required event, trace, and subject fields present
  - `event_type` in supported set: `deal.updated`, `call.completed`, `account.health_changed`
- Failure output:
  - `event_type: deal.hygiene.failed_validation`
  - `attributes.validation_errors[]`

### Phase B: Gather Context
- Tools: `endgame_mcp_context_fetch`, `crm_snapshot_fetch`
- Outputs:
  - `attributes.enrichment.timeline_summary`
  - `attributes.enrichment.last_activity_at`
  - `attributes.enrichment.directive_refs[]`

### Phase C: Run Smart Cogs in Dependency Order
1. `enrich_account_health@v1.0.0`
2. `deal_score_reasoner@v1.0.0`
3. `directive_alignment@v1.0.0`
4. `route_exec_alert@v1.0.0`
- Required generated fields:
  - `attributes.hygiene_score`
  - `attributes.score_band`
  - `attributes.recommended_play`
  - `attributes.directive_alignment`
  - `attributes.routing`

### Phase D: Approval Loop
- Tool: `approval_loop@v1.0.0`
- Input payload: `attributes.proposed_mutations[]` + directive flags.
- Decision handling:
  - `approved` -> proceed to writeback
  - `rejected|needs_info|expired` -> emit deferred event and stop

### Phase E: Execute and Emit
- Tools: `sfdc_writeback`, `emit_gtm_event`
- Success output event:
  - `event_type: deal.hygiene.remediated`
  - `attributes.approval_status: approved`
  - `attributes.writeback_actions[]`
- Deferred output event:
  - `event_type: deal.hygiene.deferred`
  - `attributes.approval_status` in `rejected|needs_info|expired`

## Optional Subagent Pattern
- Use subagents only for bounded side investigations (for example, timeline summarization).
- Keep subagents read-heavy and least-privilege.
- Subagents cannot call other subagents; sequence specialized workers from the main routine thread.

## Idempotency and Error Policy
- Idempotency key: `event_id`.
- Retry: up to 3 attempts for transient tool failures (exponential backoff).
- Permanent failure output:
  - `event_type: deal.hygiene.writeback_failed`
  - `attributes.error_class`, `attributes.error_detail`, `attributes.retry_count`
- Routine-level trigger/API limits:
  - handle as retryable transport failure and preserve `trace.trace_id`.

## Output Envelope Requirements
All routine terminal outputs must include:
- `schema_version`, `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`
- `trace.trace_id` (preserved), `trace.run_id` (current routine run)
- `subject.entity_type`, `subject.entity_id`
