# Shared Smart Cogs

Reusable smart cogs should be declared here as `.cog.yaml` documents conforming to `cog_v1`.

Guidelines:
- Prefer adding smart cogs only when used by 2+ machines.
- Keep business-machine specifics out of shared smart cogs.
- Add migration notes when bumping smart-cog version.
- Use `approval_loop` for high-impact side effects such as SFDC writes or outbound email sends.
