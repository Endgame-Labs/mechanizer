# Skill: Validate Platform Coverage

Ensure each machine supports the required adapter set and baseline artifacts.

## Objective
Prevent partial machine definitions that cannot be ported across supported runtimes.

## Required Adapter Set
- `n8n`
- `zapier`
- `tray`
- `make`
- `agentic`
- `claude-routines`
- `claw-like`

## Required Files Per Machine
- `machine.yaml`
- `README.md`
- `claw-like/HEARTBEAT.md`
- `schematics/<machine-id>/diagram.svg`

## Procedure
1. Verify all required adapter directories exist.
2. Verify required files exist.
3. Check `claw-like/HEARTBEAT.md` has required keys and parseable cron expression.
4. Verify machine README calls out trigger model and output side-effects.
5. Verify machine README includes `## ChatGPT Workspace Agents Support`.
6. Verify machine diagram exists at `schematics/<machine-id>/diagram.svg`.
7. Verify root `README.md` contains a diagram gallery entry for the machine.
8. Fail validation if any adapter folder is missing or renamed.

## Exit Criteria
- Full adapter coverage present.
- Heartbeat contract passes checks.
- Machine metadata and docs are complete.
- Diagram coverage is complete in both `docs/assets/` and root `README.md`.
- Workspace Agents support documentation exists in each machine README.

## Suggested Automation
- CI script that iterates `schematics/*-machine` directories.
- File-presence and key-presence checks.
- Optional cron parser check for HEARTBEAT schedule.
- README lint check to ensure diagram gallery includes each machine.
- README lint check to ensure `## ChatGPT Workspace Agents Support` exists per machine.
