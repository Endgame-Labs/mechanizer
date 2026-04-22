# Tray Adapter (tier-3-account-coverage-machine)

Tray implementation of tier-3 account coverage automation with callable ingest and required approval gating before side effects.

## Artifact
- `workflow.json`: project-style starter artifact.

## Trigger Design
1. Callable trigger for canonical `gtm_event_v1` ingestion.
2. Optional scheduled trigger (`0 */6 * * *`, `America/Los_Angeles`) for cohort sweeps.

## Contract Semantics
1. Normalize and validate `gtm_event_v1`.
2. Enrich account context and compute coverage signals.
3. Gate to tier-3 target segments (`low_touch`, `no_touch`).
4. Score churn/expansion trigger intensity.
5. Compose outreach plan and run approval.
6. Execute approved outbound/CRM actions.
7. Emit `tier3.coverage.executed` or `tier3.coverage.blocked`.
