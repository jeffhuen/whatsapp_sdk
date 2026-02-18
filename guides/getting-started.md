# Getting Started

This guide walks you through installing the WhatsApp SDK, configuring credentials, and sending your first message.

## Prerequisites

- Elixir 1.19+ and OTP 27+
- A [Meta Developer account](https://developers.facebook.com/) with a WhatsApp Business App
- A System User access token with `whatsapp_business_messaging` permission

## Installation

Add `whatsapp_sdk` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:whatsapp_sdk, "~> 0.1.0"}
  ]
end
```

Then fetch dependencies:

```bash
mix deps.get
```

## Configuration

Configure your credentials in `config/runtime.exs` (recommended for secrets):

```elixir
config :whatsapp_sdk,
  access_token: System.fetch_env!("WHATSAPP_ACCESS_TOKEN"),
  phone_number_id: System.fetch_env!("WHATSAPP_PHONE_NUMBER_ID"),
  business_account_id: System.get_env("WHATSAPP_BUSINESS_ACCOUNT_ID"),
  app_secret: System.get_env("WHATSAPP_APP_SECRET")
```

Then build a client from application config:

```elixir
client = WhatsApp.client()
```

Or pass credentials explicitly:

```elixir
client = WhatsApp.client("your_access_token",
  phone_number_id: "123456789",
  business_account_id: "987654321"
)
```

## Sending a Message

Use the client to call the WhatsApp Cloud API directly:

```elixir
client = WhatsApp.client()

{:ok, result} = WhatsApp.Client.request(client, :post,
  "/v23.0/#{client.phone_number_id}/messages",
  json: %{
    "messaging_product" => "whatsapp",
    "to" => "15551234567",
    "type" => "text",
    "text" => %{"body" => "Hello from Elixir!"}
  }
)
```

## Client Options

The client supports several options for tuning behavior:

| Option | Default | Description |
|--------|---------|-------------|
| `:api_version` | `"v23.0"` | API version prefix for URL construction |
| `:max_retries` | `0` | Max retry attempts for transient failures |
| `:open_timeout` | `30_000` | Connection open timeout (ms) |
| `:read_timeout` | `30_000` | Response read timeout (ms) |
| `:finch` | `WhatsApp.Finch` | Finch instance name |

### Enabling Retries

By default, retries are disabled. Enable them to automatically handle rate limits, server errors, and transient failures:

```elixir
client = WhatsApp.client("token", max_retries: 3)
```

The retry logic handles:

- **429** — Rate limited (respects `Retry-After` header)
- **500, 502, 503** — Server errors
- **Connection errors** — Network failures, timeouts
- **Meta `is_transient: true`** — Transient errors flagged by Meta

Backoff uses exponential delay with jitter to avoid thundering herd.

## Error Handling

All API calls return tagged tuples:

```elixir
case WhatsApp.Client.request(client, :post, path, json: body) do
  {:ok, data} ->
    # Success — data is the decoded JSON response
    data

  {:error, %WhatsApp.Error{code: 190}} ->
    # Invalid access token
    Logger.error("Invalid access token")

  {:error, %WhatsApp.Error{status: 429, retry_after: seconds}} ->
    # Rate limited (only if retries exhausted)
    Logger.warning("Rate limited, retry after #{seconds}s")

  {:error, %WhatsApp.Error{} = err} ->
    # Other API error
    Logger.error("WhatsApp error #{err.code}: #{err.message}")
end
```

## Response Metadata

Pass `return_response: true` to get full response metadata:

```elixir
{:ok, data, response} = WhatsApp.Client.request(client, :post, path,
  json: body,
  return_response: true
)

response.trace_id          # "AbC123dEf456" — for support tickets
response.app_usage         # %{"call_count" => 10, ...}
response.api_version       # "v23.0"
```

## Observability

The SDK emits telemetry events for every request:

```elixir
:telemetry.attach_many(
  "whatsapp-logger",
  [
    [:whatsapp, :request, :start],
    [:whatsapp, :request, :stop],
    [:whatsapp, :request, :exception],
    [:whatsapp, :request, :retry]
  ],
  fn event, measurements, metadata, _config ->
    Logger.info("#{inspect(event)} #{inspect(metadata)}")
  end,
  nil
)
```

See `WhatsApp.Telemetry` for the full event reference.

## Next Steps

- [Webhooks Guide](webhooks.md) — Receive incoming messages and status updates
- [Interactive Messages Guide](interactive-messages.md) — Build buttons, lists, and more
- [Testing Guide](testing.md) — Write isolated async tests with HTTP stubs
