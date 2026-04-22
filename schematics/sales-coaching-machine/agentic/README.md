# Agentic Adapter (sales-coaching-machine)

Provider-agnostic manager-worker orchestration for coaching generation with deterministic contract and quality gates.

## Runtime Pattern
- Manager-worker graph with resumable checkpoints and explicit stage boundaries.
- MCP-compatible tool/resource integration preferred for context and directive systems.
- Async/background continuation allowed for delayed approvals, with contract-safe final emission.

## Tool Inventory
- `validate_gtm_event_v1(payload)`
- `endgame_context.lookup(subject, attributes)`
- `call_insights.extract(transcript_id, rubric)`
- `directive_alignment.check(recommendation, directive_set_version, evidence)`
- `deal_score_reasoner.score(opportunity_context)`
- `salesforce.tasks.create(task_payload)`
- `slack.post(channel, message)`
- `event_bus.emit(event_payload)`

## Permission Model
- Worker agents can call read-only context/extraction tools.
- Only manager agent can execute side effects (`salesforce.tasks.create`, `slack.post`, `event_bus.emit`).
- Alignment failure forces `manager_approval=true` before any outbound action.
- High-risk actions require HITL decision (`approve|reject|edit`) before execution.

## Execution Contract
- Input: `gtm_event_v1` (`event_type=call.completed`)
- Output: `gtm_event_v1` (`event_type=coaching.recommendation.created`)
- Max runtime: `180s`
- Idempotency key: `event_id`

## Quality Gates
1. Schema gate: strict `gtm_event_v1` validation.
2. Evidence gate: recommendation must cite at least one transcript or CRM fact.
3. Alignment gate: `status=pass` and `score>=0.85` for auto-write.
4. Confidence gate: if below threshold, route to review queue.

## Failure Classification
- `input_invalid`: reject and emit dead-letter event.
- `context_unavailable`: retry with backoff; escalate on final failure.
- `alignment_failed`: no CRM write; notify review channel.
- `side_effect_error`: retry once, then dead-letter.

## Tracing and Evals Hooks
- Record spans for validation, extraction, recommendation, alignment, approval, side effects, and emit.
- Trace metadata must include `event_id`, `trace_id`, `run_id`, `alignment_status`, and HITL decision.
- Evals should score coaching quality, citation faithfulness, and false approve/false block rates.
