# Skill: Validate Platform Coverage

Ensure each machine supports the required adapter set and baseline artifacts.

## Objective
Prevent partial machine definitions that cannot be ported across supported runtimes.

## Required Adapter Set
- `n8n`
- `zapier`
- `tray`
- `make`
- `workato`
- `agentic`
- `claude-routines`
- `claw-like`

## Required Files Per Machine
- `machine.yaml`
- `README.md`
- `claw-like/HEARTBEAT.md`
- `schematics/<machine-id>/diagram.svg`
- `schematics/<machine-id>/workato/recipe.json`

## Procedure
1. Run `ruby scripts/validate_schematic_cleanup.rb` from the repository root.
2. Verify all required adapter directories exist.
3. Verify required files exist, including `diagram.svg` and `workato/recipe.json`.
4. Check `claw-like/HEARTBEAT.md` has required keys and parseable cron expression.
5. Verify machine README calls out trigger model and output side-effects.
6. Verify machine README includes `## Adapter Notes` and `## ChatGPT Workspace Agents Support`.
7. Verify machine README Adapter Notes mention every runtime, including Workato.
8. Verify machine diagram exists at `schematics/<machine-id>/diagram.svg`.
9. Verify every runtime README shows `../diagram.svg` directly below its title.
10. Verify root `README.md` contains a diagram gallery entry for the machine.
11. Fail validation if any adapter folder is missing or renamed.

## Exit Criteria
- Full adapter coverage present.
- Heartbeat contract passes checks.
- Machine metadata and docs are complete.
- Diagram coverage is complete in both `docs/assets/` and root `README.md`.
- Workspace Agents support documentation exists in each machine README.

## Suggested Automation
- Run `ruby scripts/validate_schematic_cleanup.rb` before committing schematic changes.
- File-presence and key-presence checks.
- Optional cron parser check for HEARTBEAT schedule.
- README lint check to ensure diagram gallery includes each machine.
- README lint check to ensure `## Adapter Notes` and `## ChatGPT Workspace Agents Support` exist per machine.
