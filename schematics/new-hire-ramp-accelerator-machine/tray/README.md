# Tray Adapter (new-hire-ramp-accelerator-machine)

Tray starter for new-hire-ramp-accelerator-machine with callable ingestion and mandatory approval gate.

## Artifact
- `workflow.json`

## Flow Contract
1. Validate `gtm_event_v1` input.
2. Dedupe by `event_id`.
3. Build onboarding package sections: territory snapshot, starter accounts, messaging kit, week-one plan.
4. Request approval.
5. Approved branch writes package + CRM tasks and emits `rep.onboarding.package_generated`.
6. Blocked branch emits `rep.onboarding.package_blocked` and performs no mutations.
