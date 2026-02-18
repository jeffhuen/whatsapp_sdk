# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-02-17

### Added

- **Core client** — `WhatsApp.Client` struct with Bearer auth, JSON/multipart encoding, and configurable timeouts
- **Automatic retries** — opt-in exponential backoff with jitter, `Retry-After` header parsing, 429/5xx/connection error handling, and Meta `is_transient` awareness
- **Connection pooling** — auto-sized Finch pool (`max(schedulers_online, 10)`)
- **Error handling** — `WhatsApp.Error` struct that parses Meta's error format (`code`, `error_subcode`, `fbtrace_id`, `is_transient`)
- **Response metadata** — `WhatsApp.Response` with named header fields (trace ID, rate limit usage, API version)
- **Telemetry** — `:start`, `:stop`, `:exception`, and `:retry` events under `[:whatsapp, :request, ...]`
- **Test helpers** — `WhatsApp.Test` with per-process HTTP stubs via NimbleOwnership for `async: true` tests
- **Code generation** — `mix whatsapp.generate` task that reads Meta's OpenAPI spec and generates service modules and resource structs
- **OpenAPI sync** — `scripts/sync_openapi.sh` downloads the latest spec from `facebook/openapi` and converts YAML to JSON
- **Pagination** — `WhatsApp.Page` with cursor-based navigation and lazy auto-paging via `Stream.unfold`
- **Deserialization** — `WhatsApp.Deserializer` with format-aware casting (ISO 8601 dates/times) and discriminator dispatch
- **Webhook verification** — `WhatsApp.Webhook` with HMAC-SHA256 signature validation and subscription verification
- **WebhookPlug** — optional Phoenix Plug with `WhatsApp.WebhookPlug.Handler` behaviour for event dispatch
- **Interactive messages** — `WhatsApp.Interactive` builders for buttons, lists, CTA URLs, flows, location requests, and products
- **CI workflows** — GitHub Actions for test matrix (Elixir 1.19-1.20, OTP 27-28), quality checks, and codegen verification
- **Spec sync workflow** — periodic OpenAPI spec sync with automatic PR generation
- **Parity report** — `scripts/parity_report.sh` for API coverage tracking

[0.1.0]: https://github.com/jeffhuen/whatsapp_sdk/releases/tag/v0.1.0
