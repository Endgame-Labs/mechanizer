# Sales Coaching Machine

## Purpose
Generate actionable coaching moments from calls, activity, and pipeline movement.

## Primary KPIs
- Manager coaching actions completed per week
- Win-rate lift on coached opportunities

## Inputs
- `gtm_event_v1` events from CRM/call intelligence/product telemetry.
- Required context providers: Endgame MCP, `endgame-cli`, and Salesforce Headless 360 surfaces.

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
