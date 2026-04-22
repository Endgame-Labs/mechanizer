# Agentic Adapter (deal-hygiene-machine)

## Purpose
Provider-neutral manager-worker orchestration that preserves deterministic `gtm_event_v1` contract boundaries.

## Runtime Pattern
- Manager-worker graph with resumable state (checkpoint per phase).
- Tool/resource access via MCP-compatible clients when available (`tools`, `resources`, optional `prompts`).
- Long-running steps may run async/background, but terminal emission remains synchronous with contract completion.

## Tool Inventory
- `validate_gtm_event`: schema validator for `gtm_event_v1`.
- `endgame_mcp_context_fetch`: pulls notes, directives, account context.
- `crm_snapshot_fetch`: retrieves latest opportunity/account state.
- `enrich_account_health`, `deal_score_reasoner`, `directive_alignment`, `route_exec_alert`: smart-cog executors.
- `approval_loop`: human-in-the-loop review gate.
- `sfdc_writeback`: mutation action (approved branch only).
- `emit_gtm_event`: normalized output publisher.

## Guardrails
- Hard fail on required contract key violations before model/tool execution.
- Apply tool-risk policy tiers:
  - Low risk: read-only context fetches can auto-run.
  - Medium risk: mutation drafts require manager review.
  - High risk: external writes/messages require HITL `approve|reject|edit`.
- Prohibit writeback tools until `approval_loop.status == approved`.
- Preserve immutable `event_id` and upstream `trace.trace_id` across all phases.

## Execution Model
- See `runbook.md` for explicit phase sequencing, retry policy, and approval semantics.
- All terminal states emit a `gtm_event_v1` event (`remediated`, `deferred`, `failed_validation`, or `failed`).

## Tracing and Evals Hooks
- Emit phase spans for validation, context, cog execution, approval, and writeback.
- Record trace attributes required for evaluation: policy outcomes, approval decision, retry count, and terminal type.
- Use offline and online evals to score directive alignment, remediation correctness, and false-positive/false-negative rates.
