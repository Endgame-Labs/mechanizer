# Claw-like Adapter (consumption-renewal-intervention-machine)

![Consumption Renewal Intervention Machine Diagram](../diagram.svg)

## Purpose
Perform daily consumption and renewal intervention sweeps with HITL before customer-facing actions.

## Heartbeat Loop (Executable Pattern)
1. Scheduler evaluates cron in timezone and computes expected_tick_at.
2. Runner acquires non-blocking distributed lock (claw.consumption_renewal_intervention); if lock exists, mark skipped_overlap and exit.
3. Load cursor window (lookback: 48h) and build deterministic candidate set.
4. Run deterministic steps first: normalize to gtm_event_v1, schema validation, dedupe, policy prechecks.
5. Run smart-cog gates from machine contract (for example: enrich_account_health, deal_score_reasoner, directive_alignment, route_exec_alert, approval_loop).
6. Build proposed_actions and apply HITL requirements before risky side effects.
7. Execute approved side effects with idempotency keys; route permanent failures to DLQ.
8. Emit terminal machine event(s), then heartbeat success record.

## Cadence and Windowing
- Schedule: 0 7 * * * (America/Los_Angeles)
- Cadence note: Daily risk sweep aligned to CS operating hours.
- Cursor lookback: 48h
- Grace window: 600 seconds
- Stale threshold: 172800 seconds

## Lock and Idempotency
- Overlap policy: forbid overlap (single active run).
- Lock strategy: transaction-scoped advisory lock (or equivalent lease lock) with TTL > max_run_seconds.
- Run idempotency key: machine_id + expected_tick_at.
- Side-effect idempotency key: event_id + action_type + target_id.
- Replays are safe: already-committed side effects are skipped, not re-applied.

## Retry and Dead-letter
- Retry classes:
  - bootstrap/scheduler transient: 2 attempts (10s, 30s)
  - provider/tool transient: 3 attempts (15s, 45s, 120s)
  - approval transport transient: 2 attempts (15s, 45s)
- Non-retryable classes: schema failure, policy deny, HITL timeout deny.
- Dead-letter sink: dlq.consumption-renewal-intervention
- DLQ payload minimum fields: machine_id, run_id, event_id, stage, error_code, retry_count, first_seen_at.

## HITL and Risk Controls
- Risky actions requiring approval: customer_email_send, crm_renewal_plan_write
- HITL timeout: 1800 seconds.
- HITL outcomes:
  - approved: continue side effects.
  - rejected or timeout: emit blocked/deferred terminal outcome; do not execute risky actions.
- During approval outage, machine enters safe mode (read/score only).

## Safe Mode
- Enter safe mode on stale transition, repeated dependency failures, or approval subsystem outage.
- In safe mode, deterministic enrichment and scoring continue, but risky side effects stay disabled.
- Emit diagnostics event: renewal.intervention.machine.safe_mode
- Exit safe mode after one full healthy run with successful heartbeat.

## References
- Kubernetes CronJob (approx scheduling, idempotency, concurrency policy, time zones): https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/
- APScheduler (misfire_grace_time, coalescing, max running jobs): https://apscheduler.readthedocs.io/en/master/userguide.html
- PostgreSQL advisory locks (try-lock and transaction/session semantics): https://www.postgresql.org/docs/current/explicit-locking.html
- PostgreSQL advisory lock functions: https://www.postgresql.org/docs/9.5/functions-admin.html
- Amazon SQS DLQ and maxReceiveCount: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html
- LangGraph durable execution and HITL pause/resume: https://docs.langchain.com/oss/python/langgraph/durable-execution
