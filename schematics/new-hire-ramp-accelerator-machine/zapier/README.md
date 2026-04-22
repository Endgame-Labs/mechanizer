# Zapier Adapter (new-hire-ramp-accelerator-machine)

Zapier starter for contract-first onboarding package generation with explicit approval before side effects.

## Artifact
- `zap.template.json`

## Trigger Paths
1. Realtime inbound webhook (`gtm_event_v1`).
2. Scheduled reconciliation every 4 hours.

## Core Flow
1. Validate `gtm_event_v1` contract fields.
2. Filter supported events.
3. Build territory/book onboarding package.
4. Request approval for package writes and CRM mutations.
5. On approval, persist package and emit `rep.onboarding.package_generated`.
6. On reject/timeout, emit `rep.onboarding.package_blocked`.

## Reliability Notes
- Use `event_id` dedupe.
- Keep side-effect retries idempotent.
- Preserve `trace_id` in all logs and emitted events.
