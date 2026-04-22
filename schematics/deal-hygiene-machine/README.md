# Deal Hygiene Machine

## Purpose
Detect and repair deal-data quality issues before forecast and inspection events.

## Primary KPIs
- Reduction in stale or invalid open opportunities
- Forecast review prep time reduction

## Inputs
- `gtm_event_v1` events from CRM/call intelligence/product telemetry.

## Outputs
- Structured actions/alerts/tasks using adapter-native constructs.
- Normalized event emissions for downstream machines.

## Platform Notes
- `n8n/`: workflow export placeholder and implementation notes.
- `zapier/`: zap template placeholder and app mapping.
- `tray/`: tray workflow placeholder and callable config.
- `make/`: scenario blueprint placeholder and module mapping.
- `agentic/`: agent-runbook for prompt and tool orchestration.
- `claude-routines/`: routine specs for deterministic orchestration.
- `claw-like/`: long-running orchestration and heartbeat contract.
