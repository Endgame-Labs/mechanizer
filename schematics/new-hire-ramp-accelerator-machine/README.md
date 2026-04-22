# New Hire Ramp Accelerator Machine

## Purpose
Generate an onboarding package immediately after rep provisioning, tailored to assigned territory/book, with contract-stable behavior across adapters.

## Onboarding Package Outputs
- Territory + book snapshot (segments, top accounts, whitespace pockets).
- Prioritized starter account list (ranked by fit and timing signal).
- Messaging kit (approved outreach starters and call openers).
- First-week execution plan (tasks, owners, milestones, due dates).

## Where It Fits
Use this machine when new reps need a high-quality starting package within minutes of provisioning, not days.

## Primary KPIs
- Provisioned reps receiving onboarding package within SLA.
- Median time-to-first-qualified-outreach for new reps.
- Ramp milestone completion rate in first 30 days.

## Trigger Models
- Realtime trigger:
  - `rep.provisioned`, `rep.territory_assigned`, `rep.book_rebalanced`.
- Batch trigger:
  - Scheduled catch-up/reconciliation every 4 hours via scheduler or `claw-like` heartbeat runtime.

## Required Context Layers
- Endgame MCP + `endgame-cli`:
  - Prior notes, account context, directives, and existing onboarding and territory artifacts.
- Salesforce Headless 360 / CRM:
  - Territory assignment, account ownership, task/checklist write targets.
- Enablement repository:
  - Approved messaging, playbooks, and onboarding rubric references.

## End-to-End Flow (Canonical)
1. Ingest event as `gtm_event_v1`.
2. Enrich territory/book context (`enrich_account_health`).
3. Align recommendations to enablement directives (`directive_alignment`).
4. Draft starter messaging and first-touch plays (`compose_outreach_message`).
5. Route escalations and owner alerts (`route_exec_alert`).
6. Gate write actions through `approval_loop`.
7. Persist approved package and emit normalized completion event.

## Smart Cogs Used (Shared)
- `enrich_account_health`
- `directive_alignment`
- `compose_outreach_message`
- `route_exec_alert`
- `approval_loop`

## Output Events (Examples)
- `rep.onboarding.package_generated`
- `rep.onboarding.package_blocked`
- `rep.onboarding.skipped_duplicate`
- `rep.onboarding.failed`

## Adapter Notes
- `n8n/`, `zapier/`, `tray/`, `make/`:
  - Keep canonical field names aligned with contract keys.
  - Keep approval gate before CRM/document mutations.
- `agentic/` and `claude-routines/`:
  - Keep cog phases explicit and deterministic at boundaries.
- `claw-like/`:
  - `HEARTBEAT.md` is schedule and liveness source of truth.

## ChatGPT Workspace Agents Support
- ChatGPT + Slack: manager/enablement prompts and status updates can run through ChatGPT Workspace with Slack handoff for reviewer notifications.
- Cloud/background runs: long onboarding assembly and delayed approval waits can execute as background runs without blocking the initiating session.
- Approval gates: preserve `approval_loop` before any CRM, docs, or outbound mutation; only approved actions proceed.
- Governance/visibility: keep run traces, tool-call history, and approval decisions auditable in workspace activity logs.
