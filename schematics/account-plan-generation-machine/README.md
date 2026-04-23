# Account Plan Generation Machine

![account-plan-generation-machine Diagram](./diagram.svg)

## Purpose
Generate structured account plans at recurring cadence and bulk scale, with stable contract semantics and shared-cog execution.

## Structured Plan Outputs
- Context snapshot (commercial, product, organizational state).
- Relationship map (champions, blockers, decision makers, influence paths).
- Whitespace analysis (coverage gaps, expansion vectors, risk surfaces).
- Plays (prioritized actions, owners, due dates, and rationale).

## Where It Fits
Use this machine when account planning must be continuously refreshed across many accounts and kept consistent across adapters.

## Primary KPIs
- Account plan coverage for in-scope accounts.
- Median account-plan freshness.
- Play execution rate from generated plans.

## Trigger Models
- Realtime trigger:
  - `account.plan.refresh_requested`, `account.tier_changed`, `planning.window_opened`.
- Batch trigger:
  - Scheduled bulk refresh every 6 hours via scheduler or `claw-like` heartbeat runtime.

## Required Context Layers
- Endgame MCP + `endgame-cli`:
  - Timeline, stakeholder signals, directives, prior plans, and interaction graph.
- Salesforce Headless 360 / CRM:
  - Account/opportunity/contact state and writeback targets.
- Product and activity telemetry:
  - Adoption trends and whitespace evidence.

## End-to-End Flow (Canonical)
1. Ingest event as `gtm_event_v1`.
2. Enrich account context (`enrich_account_health`).
3. Score risk/opportunity and whitespace priority (`deal_score_reasoner`).
4. Validate recommendations against directives (`directive_alignment`).
5. Draft plan narrative and play text (`compose_outreach_message`).
6. Route priorities and escalations (`route_exec_alert`).
7. Gate plan upsert/write actions through `approval_loop`.
8. Persist approved plan and emit normalized completion event.

## Smart Cogs Used (Shared)
- `enrich_account_health`
- `deal_score_reasoner`
- `directive_alignment`
- `compose_outreach_message`
- `route_exec_alert`
- `approval_loop`

## Output Events (Examples)
- `account.plan.generated`
- `account.plan.blocked`
- `account.plan.skipped_duplicate`
- `account.plan.failed`

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`:
  - Keep canonical field names aligned with contract keys.
  - Keep approval gate before CRM/document mutations.
- `agentic/` and `claude-routines/`:
  - Keep cog phases explicit and deterministic at boundaries.
- `claw-like/`:
  - `HEARTBEAT.md` is schedule and liveness source of truth.

## ChatGPT Workspace Agents Support
- Surfaces: supports ChatGPT workspace operation with Slack-facing summaries, review prompts, and escalations.
- Execution: supports cloud/background execution for cohort refresh and long-running planning jobs.
- Sensitive actions: gates CRM/document write actions behind explicit approval before execution.
- Governance/visibility: maintains auditable run state via contract events, approval decisions, and terminal status emission.
