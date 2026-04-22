# HEARTBEAT

machine_id: account-plan-generation-machine
heartbeat_version: v2
schedule_cron: "*/30 * * * *"
timezone: "America/Los_Angeles"
grace_period_seconds: 180
stale_after_seconds: 5400
max_run_seconds: 1200
overlap_policy: forbid
owner: "revenue-ops"
alert_channels:
  - "slack:#revops-alerts"
  - "email:revops-oncall@example.com"

lock:
  strategy: advisory_or_lease_lock
  key: "claw.account_plan_generation"
  acquire_mode: try_lock
  lease_seconds: 1500

idempotency:
  run_key: "machine_id+expected_tick_at"
  action_key: "event_id+action_type+target_id"

cursor:
  lookback_window: "90m"
  watermark_field: "last_successful_occurred_at"

retry_policy:
  bootstrap: "2 attempts (10s,30s)"
  provider_transient: "3 attempts (15s,45s,120s)"
  approval_transport: "2 attempts (15s,45s)"
  non_retryable: [schema_failure, policy_deny, approval_timeout]

dead_letter:
  enabled: true
  sink: "dlq.account-plan-generation"
  max_receive_count: 5

hitl:
  required_for: "crm_plan_publish, outbound_plan_distribution"
  timeout_seconds: 1800
  timeout_fallback: deny

safe_mode:
  enter_on: [stale_transition, repeated_transient_failures, approval_subsystem_outage]
  blocks: [crm_writes, outbound_sends, irreversible_actions]
  diagnostics_event: "account.plan.machine.safe_mode"

stale_handling:
  stale_event: "account.plan.machine.stale"
  clear_condition: "one complete healthy run with heartbeat success"

## Cron Semantics
- Cron format: minute hour day_of_month month day_of_week
- Scheduler uses timezone from this file.
- Overlap is forbidden; skipped overlapping ticks count as missed schedules.

## Success Criteria
A run is successful only when all are true:
1. deterministic validation and dedupe complete,
2. smart-cog gates complete,
3. HITL decisions resolved for risky actions,
4. approved side effects executed idempotently,
5. terminal event(s) emitted,
6. heartbeat write succeeds.

## Alerting Rules
- Warn after 1 missed due tick beyond grace window.
- Page after 2 consecutive missed due ticks or stale transition.
- Alert payload includes machine_id, run_id, expected_tick_at, last_success_at, failure_stage.

## References
- Kubernetes CronJob: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/
- APScheduler user guide: https://apscheduler.readthedocs.io/en/master/userguide.html
- PostgreSQL explicit/advisory locking: https://www.postgresql.org/docs/current/explicit-locking.html
- PostgreSQL advisory lock functions: https://www.postgresql.org/docs/9.5/functions-admin.html
- Amazon SQS DLQ: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html
- LangGraph durable execution: https://docs.langchain.com/oss/python/langgraph/durable-execution
