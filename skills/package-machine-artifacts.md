# Skill: Package Machine Artifacts

How to assemble a publishable machine package from repo source.

## Objective
Produce deterministic artifacts for one machine across selected adapters.

## Package Contents
- `machine.yaml`
- machine `README.md`
- selected platform adapter folders
- `claw-like/HEARTBEAT.md`
- machine diagram asset: `docs/assets/<machine-id>.svg`
- Workspace Agents runtime notes (if present in machine docs)
- referenced shared smart cog manifests
- contract version manifest (schema IDs + versions)

## Procedure
1. Select machine and adapter targets.
2. Copy canonical files into a staging directory.
3. Resolve shared smart cog dependencies and include exact versions.
4. Generate `MANIFEST.json` with checksums and timestamps.
5. Archive as `mechanizer-<machine-id>-<version>.tar.gz`.

## Verification
- Validate all included payload examples against included schema versions.
- Verify `MANIFEST.json` checksums match final archive contents.
- Confirm no credentials/secrets are present.
- Confirm root `README.md` includes the machine diagram for discoverability.

## Suggested Automation
- CI release job per machine.
- Integrity check step before publish/distribution.
