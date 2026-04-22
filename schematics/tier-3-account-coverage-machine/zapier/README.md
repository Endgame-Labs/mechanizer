# Zapier Adapter (tier-3-account-coverage-machine)

Low-code Zapier implementation for tier-3 account coverage with strict `gtm_event_v1` contract handling and approval-gated side effects.

## Artifact
- `zap.template.json`

## Trigger Paths
1. `Webhooks by Zapier` catch hook for realtime `gtm_event_v1` events.
2. `Schedule by Zapier` recurring sweep every 6 hours.

## Coverage Flow
1. Validate contract.
2. Enrich long-tail account context.
3. Segment gate: `low_touch`, `no_touch`.
4. Score churn and expansion triggers.
5. Compose recommended outreach.
6. Require approval for outbound/CRM mutations.
7. Emit executed or blocked terminal event.

## Reliability Notes
- Keep dedupe key `event_id` before side effects.
- Keep retries idempotent for CRM write steps.
- Ensure Paths branch that mutates systems only executes when approval is explicit.
