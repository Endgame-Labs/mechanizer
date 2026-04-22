# mechanizer

`mechanizer` is a contract-first library of reusable revenue automation schematics.

It gives you one canonical machine spec and multiple runtime adapters so the same business flow can run on:
- `n8n`
- `zapier`
- `tray`
- `make`
- `agentic` (framework-agnostic)
- `claude-routines`
- `claw-like` heartbeat-driven runners

## Why This Exists
Revenue teams want portable automation, not lock-in.

Most teams eventually mix low-code flows, API jobs, and agentic decisioning. `mechanizer` standardizes that with:
- Shared contracts for events and reusable cogs.
- Reusable machine designs (`Mechanize Schematics`).
- Runtime-specific implementations that can be swapped without redefining the business logic.

## At A Glance
- `schematics/` contains machine blueprints and adapters.
- `schematics/_shared/contracts/` defines canonical I/O contracts.
- `schematics/_shared/cogs/` defines reusable cog manifests.
- `skills/` contains contributor playbooks for validation and packaging.
- `docs/assets/` contains visual diagrams for onboarding and docs.

## Repository Layout
```text
.
├── README.md
├── AGENTS.md
├── THIRD_PARTY_TERMS.md
├── docs/assets/
├── schematics/
│   ├── _shared/
│   │   ├── contracts/
│   │   └── cogs/
│   ├── deal-hygiene-machine/
│   ├── sales-coaching-machine/
│   └── nrr-machine/
└── skills/
```

## Core Concepts
- **Machine**: End-to-end business automation with declared triggers, KPIs, SLAs, and outputs.
- **Cog**: Reusable unit of logic (deterministic code, rule gates, tool calls, or skills/agents).
- **Contract**: Schema that defines canonical payload structure.
- **Adapter**: Runtime implementation for a platform.

## Supported Cog Styles
A cog can be implemented as:
- Skill-based agentic step.
- Deterministic Python/data transform.
- CLI command wrapper.
- IF/ELSE gate or router.
- Approval-loop state machine.

All forms must honor shared contracts.

## Starter Machines
- `deal-hygiene-machine`: stage-change/cron hygiene checks with directives and approval loops.
- `sales-coaching-machine`: post-call coaching against SKO/enablement standards.
- `nrr-machine`: low-touch/no-touch retention and expansion signal machine.

## Agentic Support Model
`mechanizer` supports three agentic operating modes:
1. `agentic/`: provider-agnostic orchestration runbooks.
2. `claude-routines/`: routine-centric orchestration artifacts.
3. `claw-like/`: heartbeat-driven recurring execution via `HEARTBEAT.md`.

`claw-like` mode is intentionally cron-native and can run as a lightweight scheduler + runner loop.

## Quick Start
1. Read [`AGENTS.md`](./AGENTS.md) for architecture and contracts.
2. Open one machine under `schematics/<machine-id>/`.
3. Implement one adapter first (usually easiest for your stack).
4. Validate shared contracts and cog compatibility via `skills/` playbooks.
5. Package/publish sanitized artifacts only.

## New Contributor Workflow
1. Create or copy a machine folder.
2. Update `machine.yaml` with objective, triggers, KPIs, outputs.
3. Keep standard adapter folders, even if placeholders initially.
4. Add/modify reusable cogs in `_shared/cogs` only when broadly reusable.
5. Add examples and runbook notes.
6. Run validation checklists in `skills/`.
7. Document any breaking change and migration path.

## Diagrams
- `docs/assets/flow-overview.svg`
- `docs/assets/deal-hygiene-machine.svg`
- `docs/assets/sales-coaching-machine.svg`
- `docs/assets/nrr-machine.svg`
- `docs/assets/approval-loop-cog.svg`

## Diagram Gallery

### Flow Overview
![Flow Overview](docs/assets/flow-overview.svg)

### Deal Hygiene Machine
![Deal Hygiene Machine](docs/assets/deal-hygiene-machine.svg)

### Sales Coaching Machine
![Sales Coaching Machine](docs/assets/sales-coaching-machine.svg)

### NRR Machine
![NRR Machine](docs/assets/nrr-machine.svg)

### Approval Loop Cog
![Approval Loop Cog](docs/assets/approval-loop-cog.svg)

## Security and Publishing
- Never commit credentials, tenant IDs, webhook secrets, or customer data.
- Keep examples scrubbed/synthetic.
- See [`THIRD_PARTY_TERMS.md`](./THIRD_PARTY_TERMS.md) for platform usage boundaries.

## License
MIT for repository contents authored by Endgame Labs, Inc. See [`LICENSE`](./LICENSE).
Third-party platforms (including n8n) are governed by their own licenses and terms. See [`THIRD_PARTY_TERMS.md`](./THIRD_PARTY_TERMS.md).
