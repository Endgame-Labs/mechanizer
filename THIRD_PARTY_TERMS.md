# THIRD_PARTY_TERMS.md

This repository is designed to produce artifacts that may run on third-party services. Teams are responsible for complying with each vendor's current terms and policies before deployment.

## Scope
This file documents common obligations and practical guardrails when using generated artifacts with:
- n8n
- Zapier
- Tray
- Make
- Workato
- Anthropic Claude-related runtimes and routines
- Other LLM/API providers used by machine adapters

## Repository License Boundary
- This repository is licensed under MIT for original contents created by Endgame Labs, Inc.
- Third-party platforms, SDKs, trademarks, and hosted services remain subject to their own licenses and terms.

## n8n-Specific Note
- As of April 22, 2026, n8n is distributed under its Sustainable Use License (fair-code model with commercial restrictions).
- This repository does not relicense n8n, distribute n8n source as MIT, or grant rights beyond n8n's own license terms.
- Mechanizer's n8n artifacts are reference workflow examples intended for compliant use on properly licensed n8n instances.
- Reference: https://docs.n8n.io/sustainable-use-license/

## Baseline Compliance Requirements
- Maintain valid account licenses/subscriptions for each platform.
- Respect API rate limits, fair usage, and anti-abuse policies.
- Do not transmit prohibited content or regulated data without required safeguards.
- Keep secrets in platform-native secret stores; never commit them to source control.
- Preserve required attribution and notices when platform terms require it.

## Data Handling
- Minimize personal data in events/cogs to required operational fields.
- Define retention windows per machine and purge stale payload artifacts.
- Encrypt sensitive data at rest and in transit where supported.
- Maintain audit trails for operator actions and automated decisions.

## AI/Model Usage
- Confirm model/provider policies for training, retention, and usage rights.
- Evaluate prompt/response logs for sensitive data exposure risk.
- Add human-review checkpoints for high-impact decisions (billing, legal, HR).
- Implement deterministic fallbacks where model output quality is uncertain.

## Platform Marks
- “Zapier”, “Make”, “n8n”, “Tray”, “Workato”, and “Claude” are trademarks of their respective owners.
- This project is not endorsed by those companies unless explicitly stated.

## Operational Recommendation
For each machine, include a preflight checklist in its README covering:
- platform account and API readiness,
- policy-compliant data classes,
- incident escalation ownership,
- rollback plan.

## Disclaimer
This document is practical guidance, not legal advice. Consult counsel for production/legal interpretations.
