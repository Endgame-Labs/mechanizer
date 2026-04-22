# Agentic Adapter (tier-3-account-coverage-machine)

Runtime-agnostic orchestration contract for `tier-3-account-coverage-machine` using a **planner -> executor -> evaluator** loop with deterministic event I/O.

## Purpose
Automate low-touch/no-touch account coverage with deterministic scoring, play selection, and approval-gated outreach and CRM actions.

## Runtime Pattern
- **Planner**: validates `gtm_event_v1`, decomposes into tool steps, and sets risk tier.
- **Executor**: runs tools with checkpointed state and idempotency keys.
- **Evaluator**: verifies policy, evidence, and output schema before side effects + emit.
- **Manager ownership**: only manager node can approve terminal actions and emit final events.

## Event and Tool Contracts
- Input/output envelope: `gtm_event_v1`.
- Required event fields at ingest: `schema_version`, `event_id`, `event_type`, `source`, `occurred_at`, `ingested_at`, `trace.trace_id`, `subject.entity_type`, `subject.entity_id`.
- Tool definitions use explicit JSON Schema contracts and deterministic response shapes.
- Prefer strict tool schemas (no undeclared fields) for mutation-capable tools.

### Tool Class Policy
- `read_context`: MCP reads, warehouse/CRM snapshot reads.
- `reasoning_transform`: scoring/summarization/cog transforms.
- `write_action`: CRM updates, task creation, email/sequence sends.
- `control`: approval gate, dedupe store, event emitter.

## Provider Support Posture

### OpenAI-Style Agents
- Supported pattern: Responses API / Agents SDK with function tools + MCP + optional shell tool.
- `tool_choice` may be used to constrain tool invocation behavior.
- Use background mode for long-running or delayed-approval runs.
- For MCP connectors, keep sensitive tool calls approval-gated.

### Claude-Compatible Agents
- Supported pattern: Messages API tool loop (`stop_reason: "tool_use"` -> execute -> `tool_result`).
- Tool contracts use `name` + `input_schema`; set strict tool behavior when needed.
- MCP connector supports remote MCP tool calling directly; local stdio/prompt/resource flows require client-managed MCP integration.

### Non-Provider Runtime Engines
- LangGraph/Temporal-style durable execution is valid if checkpoints are deterministic and idempotent.
- Persist run state between planner/executor/evaluator phases to support retries and HITL resumes.

## MCP + CLI Integration Pattern
- Discover and cache tools via `tools/list`; invoke via `tools/call`.
- Fetch contextual docs/data via `resources/list` + `resources/read`.
- Load reusable instruction templates via `prompts/list` + `prompts/get` (client-managed where required).
- For CLI wrappers, enforce allowlist commands, timeout budgets, and stdout/stderr capture for audit.

## Approval/HITL Policy
Outbound outreach and CRM note/task mutations require HITL approval.

## Scheduled and Background Loop Pattern (Optional)
- Trigger modes: event-driven, cron-driven, or hybrid.
- For schedules, run planner in bounded windows and emit explicit no-op heartbeat events when no action is required.
- Long-running work may continue in background, but terminal contract emission must remain idempotent and replay-safe.

## References
- OpenAI Agents SDK: https://developers.openai.com/api/docs/guides/agents
- OpenAI Using tools: https://developers.openai.com/api/docs/guides/tools
- OpenAI Function calling (strict mode): https://developers.openai.com/api/docs/guides/function-calling
- OpenAI MCP and Connectors: https://developers.openai.com/api/docs/guides/tools-connectors-mcp
- OpenAI Background mode: https://developers.openai.com/api/docs/guides/background
- OpenAI Shell tool: https://developers.openai.com/api/docs/guides/tools-shell
- Anthropic tool use overview: https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview
- Anthropic define tools/tool_choice: https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools
- Anthropic MCP connector: https://platform.claude.com/docs/en/agents-and-tools/mcp-connector
- MCP spec (tools/resources/prompts): https://modelcontextprotocol.io/specification
- LangGraph durable execution: https://docs.langchain.com/oss/python/langgraph/durable-execution
