# Sales Coaching Routine Spec

## Contracts
- Input contract: `gtm_event_v1`
- Output contract: `gtm_event_v1` (`event_type=coaching.recommendation.created`)
- Trigger expectation: machine events routed into this routine via API/schedule/GitHub trigger plumbing

## Claude Runtime Assumptions (Apr 22, 2026)
- Executes in Anthropic-managed Claude Code routine sessions.
- No permission-mode picker or in-run approval prompt exists for routine runs.
- Explicit approval is a machine policy concern and must remain in `approval_loop`.

## Stage Flow
1. **Precheck**
- Validate schema and required fields (`event_id`, `subject.id`, `attributes.opportunity_id`, `attributes.rep_email`).
- Accept machine trigger types (`call.completed`, `deal.stage_changed`, `rep.activity_low`).
- If invalid, emit dead-letter result and stop.

2. **Context Retrieval**
- Tool call: `get_endgame_context(trace_id, subject, attributes)`
- Tool call: `extract_call_insights(call_id, transcript_id, rubric='discovery,next_steps,stakeholder_map')`
- Merge into `context_bundle`.

3. **Recommendation Draft**
- Generate 1 primary recommendation and 1 fallback recommendation.
- Include evidence references as `evidence_refs[]`.

4. **Directive Alignment Check**
- Tool call: `check_directive_alignment(recommendation, directive_set_version, evidence_refs)`
- Decision:
  - Pass + score >= 0.85: proceed to execution eligibility.
  - Pass + score < 0.85: route to manager approval.
  - Fail: route to manual review.

5. **Approval Loop (Policy Gate)**
- Tool call: `approval_loop(recommendation_package, alignment_score, trace_id)`
- Required outcomes:
  - `approved`: permit CRM write path.
  - `rejected|needs_info|expired`: emit review-required event and stop.

6. **Execution Path**
- Approved path:
  - Tool call: `create_salesforce_task(opportunity_id, rep_email, recommendation, trace_id)`
  - Tool call: `emit_event(output_event)`
- Manual/review path:
  - Tool call: `emit_event(output_event_with_status_needs_review)`
  - Tool call: `notify_review_channel(trace_id, failure_reason)`

## Output Shape
```json
{
  "event_type": "coaching.recommendation.created",
  "source": "claude-routines",
  "trace": { "trace_id": "<trace_id>" },
  "subject": { "type": "call", "id": "<call_id>" },
  "attributes": {
    "alignment_status": "pass|fail",
    "alignment_score": 0.0,
    "coaching_priority": "low|medium|high",
    "recommended_action": "string",
    "evidence_refs": ["transcript:...", "crm:..."]
  }
}
```

## Quality Gates
- Recommendation must have at least 1 transcript citation.
- Alignment score threshold for auto-write eligibility: `0.85`.
- If context age > 24h, mark `context_freshness=stale` and require review.

## Subagent Use Constraints
- Subagents are optional for heavy research/extraction only.
- Subagents run in isolated context windows and should return summarized findings.
- Subagents cannot spawn subagents; chain from the main thread when multiple specialists are needed.

## Fallback Paths
- Missing transcript: generate recommendation from CRM activity only; force manual review.
- Alignment tool unavailable: retry 3x, then emit `needs_review` without CRM write.
- Salesforce write failure: retry once; if failure persists, emit dead-letter event.
- Routine API trigger limit or hourly cap reached: retry with backoff and dedupe by `event_id`.
