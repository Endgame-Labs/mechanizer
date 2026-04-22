# Skill: Validate Cog Compatibility

Checks reusable cog definitions for semantic and structural compatibility.

## Objective
Prevent shared cog changes from silently breaking machine adapters.

## Compatibility Rules
- New optional input/output fields: allowed.
- New required input fields: breaking unless version bumped.
- Removing guaranteed output fields: breaking.
- Changing `failure_mode` semantics: breaking unless version bumped.

## Procedure
1. Diff changed `.cog.yaml` against previous version.
2. Compare required fields, guaranteed outputs, and execution semantics.
3. Require version bump for any breaking delta.
4. Ensure downstream machines list compatible cog versions.

## Exit Criteria
- No unresolved compatibility violations.
- Versioning aligns with semantic change level.
- Release notes include migration guidance when needed.
