# Make Adapter (pipeline-review-intelligence-machine)

Last validated against official Make docs: 2026-04-22.

## Artifact
- `scenario.json`: blueprint-style scenario reference.

## Scenario Shape
1. Receive pipeline-review triggers and normalize canonical fields.
2. Dedupe by `event_id`.
3. Enrich context and score deal-level priorities.
4. Iterate deal findings and aggregate review packet.
5. Run approval loop before outbound summaries or CRM writes.
6. Execute approved actions and emit completed/blocked event.

## Operator Notes
- Keep sequential processing for stage-change bursts around forecast calls.
- Add route filters for segment, stage, and forecast category.
- Keep dead-letter route for semantic/data-contract failures.

## Approval Placement
- Approval loop must remain before Slack digest and Salesforce writeback modules.

## References
- https://help.make.com/router
- https://help.make.com/iterator
- https://help.make.com/aggregator
- https://help.make.com/automatic-retry-of-incomplete-executions
- https://help.make.com/overview-of-error-handling
- https://help.make.com/scenario-run-replay
