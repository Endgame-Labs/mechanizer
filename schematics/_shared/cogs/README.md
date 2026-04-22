# Shared Smart Cogs

Reusable smart cogs should be declared here as `.cog.yaml` documents conforming to `cog_v1`.

Guidelines:
- Prefer adding smart cogs only when used by 2+ machines.
- Keep business-machine specifics out of shared smart cogs.
- Add migration notes when bumping smart-cog version.
- Use `approval_loop` for high-impact side effects such as SFDC writes or outbound email sends.

Current shared smart-cog set:
- `approval_loop`: human-in-the-loop approval gate before high-impact actions.
- `enrich_account_health`: deterministic + feature enrichment for account/deal health.
- `route_exec_alert`: severity-based alert target selection.
- `deal_score_reasoner`: score-band calculation and next-play recommendation.
- `directive_alignment`: QA pass/fail against enablement directives.
- `compose_outreach_message`: outbound message draft creation from approved plays.
