# WhatsApp SDK for Elixir

[![Hex.pm](https://img.shields.io/hexpm/v/whatsapp_sdk.svg)](https://hex.pm/packages/whatsapp_sdk)
[![CI](https://github.com/jeffhuen/whatsapp_sdk/actions/workflows/ci.yml/badge.svg)](https://github.com/jeffhuen/whatsapp_sdk/actions/workflows/ci.yml)

Comprehensive Elixir SDK for the [WhatsApp Business Platform Cloud API](https://developers.facebook.com/docs/whatsapp/cloud-api),
generated from Meta's official [OpenAPI spec](https://github.com/facebook/openapi) with full API coverage.

> **Note:** This is not an official Meta SDK. Meta does not publish a
> first-party Elixir library. This project is generated from Meta's
> [OpenAPI spec](https://github.com/facebook/openapi) for the WhatsApp
> Business Platform, follows the same API surface, and is tested for
> parity against the spec. The goal is an idiomatic Elixir experience
> with complete API coverage.

### What's Included

The **SDK layer** provides typed resource structs, dedicated service modules,
and auto-paging pagination — all generated from the spec with full
documentation. The **client layer** handles HTTP execution via Finch with
connection pooling, automatic retries, request encoding, response
deserialization, and telemetry.

Together, the full Cloud API surface is covered: 79 service modules,
352 typed resource structs, 113 API operations across 55 domains, webhook
signature verification, interactive message builders, and per-process
test stubs.

## Installation

Add `whatsapp_sdk` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:whatsapp_sdk, "~> 0.1.0"}
  ]
end
```

Requires **Elixir 1.19+** and **OTP 27+**.

## Configuration

```elixir
# config/runtime.exs
config :whatsapp_sdk,
  access_token: System.fetch_env!("WHATSAPP_ACCESS_TOKEN"),
  phone_number_id: System.fetch_env!("WHATSAPP_PHONE_NUMBER_ID")
```

Optional global defaults (all have sensible defaults if omitted):

```elixir
config :whatsapp_sdk,
  access_token: "your_token",
  phone_number_id: "12345",
  waba_id: "67890",              # WhatsApp Business Account ID
  api_version: "v23.0",          # pin API version
  max_retries: 3,                # default: 0
  base_url: "https://graph.facebook.com"
```

## Quick Start

```elixir
client = WhatsApp.client()

# Send a text message
{:ok, result} = WhatsApp.Messages.MessagesService.send_message(client, %{
  "messaging_product" => "whatsapp",
  "to" => "15551234567",
  "type" => "text",
  "text" => %{"body" => "Hello from Elixir!"}
})

# Retrieve media metadata
{:ok, media} = WhatsApp.Media.RootService.get_media_url(client, "media_id_123")

# Delete a message template
{:ok, _} = WhatsApp.Templates.MessageTemplatesService.delete_template_by_name(client,
  name: "my_template"
)
```

Responses are automatically deserialized into typed structs:

```elixir
result.__struct__  #=> WhatsApp.Resources.SendMessage
media.__struct__   #=> WhatsApp.Resources.GetMediaUrl
```

Override config per-client for multi-account scenarios:

```elixir
client = WhatsApp.client("other_token",
  phone_number_id: "99999",
  max_retries: 5
)
```

### Handle errors

```elixir
case WhatsApp.Messages.MessagesService.send_message(client, params) do
  {:ok, result} ->
    result

  {:error, %WhatsApp.Error{code: 190}} ->
    Logger.error("Invalid access token")

  {:error, %WhatsApp.Error{status: 429, retry_after: seconds}} ->
    Logger.warning("Rate limited, retry after #{seconds}s")

  {:error, %WhatsApp.Error{} = err} ->
    Logger.error("WhatsApp error #{err.code}: #{err.message}")
end
```

### Receive webhooks (Phoenix)

```elixir
# router.ex
forward "/webhook/whatsapp", WhatsApp.WebhookPlug,
  app_secret: "your_app_secret",
  verify_token: "your_verify_token",
  handler: MyApp.WhatsAppHandler

# handler.ex
defmodule MyApp.WhatsAppHandler do
  @behaviour WhatsApp.WebhookPlug.Handler

  @impl true
  def handle_event(%{"messages" => messages}) do
    Enum.each(messages, &process_message/1)
    :ok
  end

  def handle_event(_event), do: :ok
end
```

### Build interactive messages

```elixir
alias WhatsApp.Interactive

payload =
  Interactive.buttons("Would you like to proceed?")
  |> Interactive.button("yes", "Yes")
  |> Interactive.button("no", "No")
  |> Interactive.build()
```

### Write tests

```elixir
# test/test_helper.exs
WhatsApp.Test.start()
ExUnit.start()

# test/my_app/notifier_test.exs
defmodule MyApp.NotifierTest do
  use ExUnit.Case, async: true

  setup do
    WhatsApp.Test.stub(fn _request ->
      %{status: 200, body: ~s({"messages":[{"id":"wamid.123"}]}), headers: []}
    end)
    :ok
  end

  test "sends message" do
    assert {:ok, _} = MyApp.Notifier.send("Hello!")
  end
end
```

## Features

### SDK

- **Full API coverage** — every endpoint from Meta's v23.0 OpenAPI spec, with
  dedicated service modules organized by domain
- **Typed resources** — API responses are deserialized into 352 typed Elixir
  structs with `@type t` definitions via an object type registry
- **Auto-paging pagination** — cursor-based `WhatsApp.Page` with lazy
  `Stream.unfold` auto-paging for list endpoints
- **Webhook verification** — HMAC-SHA256 signature verification with optional
  Phoenix Plug and Handler behaviour
- **Interactive messages** — pipeline builders for buttons, lists, CTA URLs,
  flows, location requests, and product messages
- **Documentation** — `@moduledoc`, `@doc`, and `@spec` on all generated
  modules, sourced from the OpenAPI spec

### Client

- **Finch HTTP client** — HTTP/2-capable with connection pooling via NimblePool,
  zero JSON deps (uses Elixir 1.19 native `JSON`)
- **Automatic retries** — exponential backoff with jitter, `Retry-After`
  parsing, Meta `is_transient` awareness
- **Response deserialization** — JSON to typed structs via object type registry
- **Telemetry** — `:start`, `:stop`, `:exception`, `:retry` events for every
  request
- **Per-client configuration** — explicit struct with no global mutable state,
  safe for concurrent use with multiple tokens or accounts
- **Test stubs** — per-process HTTP stubs via NimbleOwnership for
  `async: true` tests

## Guides

- [Getting Started](guides/getting-started.md) — installation, configuration, first API call, error handling
- [Webhooks](guides/webhooks.md) — signature verification, WebhookPlug setup
- [Interactive Messages](guides/interactive-messages.md) — buttons, lists, CTA URLs, flows, products
- [Testing](guides/testing.md) — process-scoped HTTP stubs with `async: true` support

## Telemetry Events

| Event | Measurements | Metadata |
|-------|-------------|----------|
| `[:whatsapp, :request, :start]` | `system_time` | `method`, `path` |
| `[:whatsapp, :request, :stop]` | `duration` | `method`, `path`, `status` |
| `[:whatsapp, :request, :exception]` | `duration` | `method`, `path`, `kind`, `reason` |
| `[:whatsapp, :request, :retry]` | `system_time` | `method`, `path`, `attempt`, `reason`, `wait_ms` |

## Development

```bash
# Sync the latest spec
./scripts/sync_openapi.sh

# Regenerate modules
mix whatsapp.generate --clean

# Verify
mix compile --warnings-as-errors
mix test
mix credo --strict
mix dialyzer
```

### Code Generation

The SDK is auto-generated from Meta's WhatsApp Business Platform OpenAPI spec
via `mix whatsapp.generate`. The generator produces:

- **79 service modules** with typed `@spec` annotations
- **352 resource structs** with `@type t` definitions
- **1 object type registry** mapping schema names to modules (360 entries)

Organized across **55 API domains** covering **113 operations**.

### Parity Testing

Spec parity is a hard invariant. The test suite includes dedicated parity
assertions comparing the generated module set against the OpenAPI spec —
domain count, operation count, service module count, and resource module count.

## References

- [WhatsApp Cloud API Documentation](https://developers.facebook.com/docs/whatsapp/cloud-api)
- [Meta Business SDK — Getting Started](https://developers.facebook.com/docs/business-sdk/getting-started)
- [Meta OpenAPI Spec Repository](https://github.com/facebook/openapi)

## License

MIT — see [LICENSE](LICENSE) for details.
