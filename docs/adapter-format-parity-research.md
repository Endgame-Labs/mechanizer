# Adapter Format Parity Research (April 2026)

This note captures the public sources used to validate adapter artifact formats for `mechanizer` schematics.

## Summary
- `n8n/workflow.json`: aligns with n8n import/export workflow JSON shape and is generally importable.
- `zapier/zap.template.json`: reference template/spec; not a native Zapier account export bundle.
- `tray/workflow.json`: reference scaffold; not a native Tray export envelope.
- `make/scenario.json`: blueprint-style reference; not guaranteed to be directly importable as a raw Make blueprint export.

## Public Sources

### n8n
- Official import/export docs:
  - https://docs.n8n.io/workflows/export-import/
- Open/community workflow catalog:
  - https://n8n.io/workflows/
- Public codebase:
  - https://github.com/n8n-io/n8n

### Zapier
- Official Team/Enterprise JSON import/export:
  - https://help.zapier.com/hc/en-us/articles/8496308481933-Import-and-export-Zaps-in-your-Team-or-Enterprise-account
- Official template sharing:
  - https://help.zapier.com/hc/en-us/articles/8496292155405-Share-a-template-of-your-Zap
- Public template gallery:
  - https://zapier.com/templates

### Tray
- Official import/export docs:
  - https://docs.tray.ai/platform/enterprise-core/lifecycle-management/import-export
- Official workflow export JSON shape examples:
  - https://tray.ai/documentation/developer/embedded-apis/workflows
- Public template/library page:
  - https://tray.ai/documentation/library/

### Make
- Official blueprints docs:
  - https://help.make.com/blueprints
- Public community blueprint guidance:
  - https://community.make.com/t/feature-spotlight-improved-scenario-blueprint-import/106569

## Implementation Guidance
- Keep these artifacts as contract-first references where vendor-native import envelopes are not stable or publicly standardized.
- Treat direct importability as platform-specific:
  - n8n: direct import expected.
  - Zapier/Tray/Make: expect some manual reconstruction or export-normalization in target tenant/workspace.
- Keep `gtm_event_v1` envelope stable so runtime adapters can be migrated without changing machine semantics.
