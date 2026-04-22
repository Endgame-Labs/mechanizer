# Make Adapter (stage-change-deal-review-machine)

## Artifact
- `scenario.json`: importable blueprint-style starter artifact.

## Runtime Pattern
1. Trigger via custom webhook for stage-change events.
2. Normalize inbound payload to `gtm_event_v1`.
3. Run shared smart cogs for qualification/risk/missing-field review.
4. Execute mandatory `approval_loop`.
5. Approved path applies CRM writeback.
6. Non-approved path posts Slack findings.
7. Emit terminal event and store idempotency status.

## Contract and Approval Semantics
- Preserve canonical contract keys across all modules.
- No mutation side effects without explicit `approved` status.
