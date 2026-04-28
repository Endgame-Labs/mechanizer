# AGENTS.md

Technical architecture, contracts, and contribution standards for `mechanizer`.

## 1) System Architecture

`mechanizer` is contract-first:
- Define canonical contracts and smart-cog interfaces once.
- Implement machine behavior once in `machine.yaml`.
- Map that behavior into platform adapters.

### Layers
- Shared layer: `schematics/_shared/*`
- Machine layer: `schematics/<machine-id>/*`
- Adapter layer: `n8n`, `zapier`, `tray`, `make`, `workato`, `agentic`, `claude-routines`, `claw-like`

### Design Goal
Machine intent stays stable while adapter implementations vary.

## 2) Required Machine Directory Contract

Each machine directory must contain:
```text
schematics/<machine-id>/
  machine.yaml
  README.md
  n8n/
  zapier/
  tray/
  make/
  workato/
  agentic/
  claude-routines/
  claw-like/
    HEARTBEAT.md
```

Placeholders are acceptable for early drafts, but folder presence is mandatory for compatibility tracking.

## 3) Canonical Contracts

Shared contracts live in:
- `schematics/_shared/contracts/gtm_event_v1.schema.json`
- `schematics/_shared/contracts/gtm_event_v1.schema.yaml`
- `schematics/_shared/contracts/cog_v1.schema.json`
- `schematics/_shared/contracts/cog_v1.schema.yaml`

### `gtm_event_v1` semantics
- `event_id`: immutable dedupe key.
- `event_type`: `noun.verb` style.
- `source`: producer system.
- `occurred_at`: business timestamp.
- `ingested_at`: adapter ingest timestamp.
- `trace`: correlation lineage.
- `subject`: primary entity envelope.
- `attributes`: extension map.

### `cog_v1` semantics
- `cog`: identity, ownership, category, version (smart-cog contract key).
- `input_contract`: required and optional fields.
- `output_contract`: emitted and guaranteed fields.
- `execution`: idempotency, timeout, retries, backoff.

## 4) Smart Cog Abstraction

A smart cog is a reusable logic primitive and may be implemented as:
- Agentic skill/tool chain.
- Deterministic Python transform.
- CLI-backed operation.
- Rule gate (if/else routing).
- Approval workflow loop.

All implementations must preserve the same contract behavior.

## 5) Agentic Modes

### `agentic/`
Provider-agnostic orchestration runbook for manager-worker style execution and approval gates.

### `claude-routines/`
Routine-centric implementation docs and routine assets for Claude-oriented flows.

### `claw-like/`
Heartbeat-runner compatible mode where `HEARTBEAT.md` drives scheduled execution and liveness monitoring.

`claw-like` exists so recurring machine execution can run in cron-like environments without requiring a visual flow platform.

## 6) HEARTBEAT Contract

Every machine must include `claw-like/HEARTBEAT.md` with:
- `machine_id`
- `heartbeat_version`
- `schedule_cron`
- `timezone`
- `grace_period_seconds`
- `stale_after_seconds`
- `owner`
- `alert_channels`

### Cron Semantics
- Five-field cron: `minute hour day_of_month month day_of_week`
- `*/N` = every N intervals
- `A-B` = range
- `A,B,C` = discrete list
- Interpret schedule in declared `timezone`

## 7) Machine Metadata Contract (`machine.yaml`)

Required keys:
- `machine_id`
- `version`
- `owners`
- `objective`
- `kpis`
- `triggers`
- `inputs`
- `outputs`
- `slo`

Recommended keys:
- `dependencies`
- `feature_flags`
- `security`
- `rollback`

## 8) Adding a New Schematic

1. Copy an existing machine folder as a template.
2. Rename IDs and update `machine.yaml`.
3. Keep all required adapter folders.
4. Add/adjust reusable smart cogs under `_shared/cogs` when generic.
5. Add runbook notes and sample payloads.
6. Validate contracts and compatibility.
7. Document migration notes for breaking changes.

## 9) Validation Workflow

Use skills in `skills/`:
- `validate-schematic-contracts.md`
- `validate-cog-compatibility.md`
- `validate-platform-coverage.md`
- `package-machine-artifacts.md`

Validation must confirm:
- Shared contract compatibility.
- Smart-cog version correctness.
- Required adapter coverage presence.
- Heartbeat metadata validity for claw-like mode.
- Machine diagram exists at `schematics/<machine-id>/diagram.svg`.
- Root `README.md` diagram gallery includes the machine.

## 10) Compatibility Policy

Breaking changes include:
- Removing required input fields.
- Removing guaranteed output fields.
- Changing execution semantics that alter downstream behavior.

Breaking changes require version bumps and migration notes.
