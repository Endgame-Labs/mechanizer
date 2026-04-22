# Skill: Validate Schematic Contracts

Use this workflow before merging any machine or shared-contract changes.

## Objective
Ensure event payloads and machine examples conform to canonical schema contracts.

## Inputs
- Updated contracts in `schematics/_shared/contracts/`
- Machine examples in `schematics/<machine-id>/`

## Procedure
1. Verify schema IDs and versions are unchanged unless intentionally bumped.
2. Validate all machine example payloads against `gtm_event_v1`.
3. Validate `.cog.yaml` documents against `cog_v1`.
4. Fail on unknown required fields or incompatible type changes.
5. Generate a compatibility note if schema changes are non-additive.

## Exit Criteria
- Zero validation errors.
- Any breaking change is documented with migration path.
- Machine README reflects new/changed required fields.

## Suggested Tooling
- `ajv` or equivalent JSON Schema validator.
- CI job that runs validation on each PR.
