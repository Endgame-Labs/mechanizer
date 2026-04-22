# Claw-like Adapter (tier-3-account-coverage-machine)

`claw-like` provides scheduled long-tail coverage execution where visual flow tools are not used.
`HEARTBEAT.md` is the source of cadence and liveness metadata.

## Runtime Model
1. Parse `schedule_cron` and `timezone` from heartbeat contract.
2. Run non-overlapping job lock for each scheduled tick.
3. Execute discovery, scoring, approval, and side effects.
4. Emit heartbeat only after terminal machine completion.

## Safe Mode
- Enter safe mode on stale heartbeat or repeated failures.
- In safe mode:
  - continue monitoring and scoring
  - suppress outbound and CRM side effects
  - emit diagnostic event `tier3.coverage.safe_mode`
