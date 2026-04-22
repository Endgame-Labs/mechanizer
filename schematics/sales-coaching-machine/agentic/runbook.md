# Agentic Runbook (sales-coaching-machine)

## Runtime Assumptions
- Provider-neutral orchestration (OpenAI Agents SDK, LangGraph, or CrewAI style runtimes are acceptable).
- Checkpoint state per stage to support retries, interrupts, and HITL resume.
- MCP-first integration pattern for external context/directive systems when supported.

## Stage 1: Ingest + Validate
1. Receive `call.completed` payload from adapter ingress.
2. Run `validate_gtm_event_v1(payload)`.
3. If invalid:
- Emit dead-letter event with `reason=input_invalid`.
- Stop execution.

## Stage 2: Context Assembly
1. Call `endgame_context.lookup(subject, attributes)` using `account_id`, `opportunity_id`, and `rep_email`.
2. Call `call_insights.extract(transcript_id, rubric='discovery+next-step-quality')`.
3. Merge facts into `working_context` with trace preservation.
4. If any call fails, retry up to 3 attempts (`5s`, `20s`, `45s`).

## Stage 3: Draft Coaching Recommendation
1. Worker generates candidate recommendation with explicit evidence citations.
2. Worker calls `deal_score_reasoner.score(opportunity_context)` to determine urgency tier.
3. Manager normalizes candidate into output contract shape.

## Stage 4: Directive Alignment Gate
1. Call `directive_alignment.check(recommendation, directive_set_version, evidence)`.
2. Decision rules:
- `pass` and `score>=0.85`: continue to Stage 5.
- `pass` but `score<0.85`: route to manager approval queue.
- `fail`: route to manual review and skip CRM write.

## Stage 5: Guardrails + HITL
1. Apply guardrails before side effects:
- Input guardrail: payload shape + scope checks.
- Tool guardrail: block unsafe tool args and disallowed channels.
- Output guardrail: recommendation must include evidence and policy-safe language.
2. Trigger HITL when:
- alignment score below auto-write threshold
- recommendation includes risky claims or unsupported assertions
- any outbound side effect is requested outside default template
3. HITL decisions:
- `approve`: continue
- `reject`: emit blocked/dead-letter outcome and stop
- `edit`: manager applies constrained edits then re-runs alignment check

## Stage 6: Side Effects + Emit
1. For approved recommendations, call `salesforce.tasks.create(...)`.
2. Emit `coaching.recommendation.created` to event bus with:
- `alignment_status`
- `alignment_score`
- `urgency_tier`
- `trace_id`
3. If task creation fails, retry once; then dead-letter and Slack escalation.

## Fallback Paths
- Transcript missing: fallback to call summary and CRM notes; mark `evidence_quality=degraded`.
- Directive service timeout: queue for delayed alignment recheck (max delay 15 min).
- Duplicate `event_id`: treat as idempotent replay and return prior result.

## Operational Checks
- p95 runtime under `180s`.
- Dead-letter rate under `1%` of processed events.
- Manual review queue drained within one business day.

## Trace Requirements
- Required spans: `ingest_validate`, `context_lookup`, `insights_extract`, `recommendation_draft`, `alignment_gate`, `approval_wait`, `side_effects`, `emit`.
- Every run records `event_id`, `trace_id`, `run_id`, retry counts, and guardrail outcomes.
- Include cost/latency by tool and model call for SLO and budget monitoring.

## Evals
- Maintain golden set of transcript/context pairs with expected recommendation characteristics.
- Grade:
  - Evidence faithfulness and citation correctness.
  - Directive alignment consistency.
  - HITL correctness (approved, rejected, edited path behavior).
- Treat safety regressions (unsafe claims, no-evidence outputs, unapproved side effects) as release blockers.
