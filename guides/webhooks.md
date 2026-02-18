# Webhooks

This guide covers receiving and verifying webhook events from the WhatsApp Business API.

## Overview

Meta delivers webhook events (incoming messages, delivery receipts, status updates) as HTTP POST requests signed with HMAC-SHA256. The SDK provides two levels of integration:

1. **`WhatsApp.Webhook`** — Low-level signature verification functions
2. **`WhatsApp.WebhookPlug`** — Drop-in Phoenix Plug with event dispatch

## Quick Start with WebhookPlug

The fastest way to handle webhooks in a Phoenix app:

### 1. Create a handler module

```elixir
defmodule MyApp.WhatsAppHandler do
  @behaviour WhatsApp.WebhookPlug.Handler

  require Logger

  @impl true
  def handle_event(%{"messages" => messages} = _event) do
    Enum.each(messages, fn message ->
      Logger.info("Received message: #{inspect(message)}")
    end)
    :ok
  end

  def handle_event(%{"statuses" => statuses} = _event) do
    Enum.each(statuses, fn status ->
      Logger.info("Status update: #{status["status"]} for #{status["id"]}")
    end)
    :ok
  end

  def handle_event(_event), do: :ok
end
```

### 2. Add the route in your router

```elixir
# In your Phoenix router
forward "/webhook/whatsapp", WhatsApp.WebhookPlug,
  app_secret: Application.compile_env!(:my_app, :whatsapp_app_secret),
  verify_token: Application.compile_env!(:my_app, :whatsapp_verify_token),
  handler: MyApp.WhatsAppHandler
```

### 3. Configure the raw body reader

Phoenix consumes the request body during JSON parsing, but signature verification needs the raw body. Add a cache body reader to your endpoint:

```elixir
# lib/my_app_web/endpoint.ex
plug Plug.Parsers,
  parsers: [:json],
  pass: ["application/json"],
  body_reader: {MyApp.CacheBodyReader, :read_body, []},
  json_decoder: JSON
```

```elixir
# lib/my_app_web/cache_body_reader.ex
defmodule MyApp.CacheBodyReader do
  def read_body(conn, opts) do
    case Plug.Conn.read_body(conn, opts) do
      {:ok, body, conn} ->
        {:ok, body, Plug.Conn.assign(conn, :raw_body, body)}

      other ->
        other
    end
  end
end
```

The plug checks `conn.assigns[:raw_body]` first, then falls back to `Plug.Conn.read_body/1`.

## Low-Level Verification

For custom setups or non-Phoenix apps, use `WhatsApp.Webhook` directly.

### Subscription Verification

When you register a webhook URL in the Meta dashboard, Meta sends a GET request to verify your endpoint:

```elixir
case WhatsApp.Webhook.verify_subscription(params, "my_verify_token") do
  {:ok, challenge} ->
    # Respond with 200 and the challenge string
    send_resp(conn, 200, challenge)

  {:error, _error} ->
    send_resp(conn, 403, "Forbidden")
end
```

The function handles both dot notation (`hub.mode`) and underscore notation (`hub_mode`) parameter formats.

### Signature Validation

Validate that a POST payload was signed by Meta:

```elixir
signature = get_req_header(conn, "x-hub-signature-256") |> List.first("")

if WhatsApp.Webhook.valid?(raw_body, signature, app_secret) do
  # Payload is authentic — process events
  {:ok, payload} = JSON.decode(raw_body)
  process_events(payload)
else
  send_resp(conn, 403, "Invalid signature")
end
```

### Computing Signatures

For testing or debugging, compute a signature manually:

```elixir
sig = WhatsApp.Webhook.compute_signature(payload, app_secret)
# => "0329a06b62cd16b33eb6792be8c60b158d89a2ee3a876fce9a881ebb488c0914"
```

## Webhook Payload Structure

Meta delivers webhook payloads with this structure:

```json
{
  "object": "whatsapp_business_account",
  "entry": [
    {
      "id": "WABA_ID",
      "changes": [
        {
          "field": "messages",
          "value": {
            "messaging_product": "whatsapp",
            "metadata": { "phone_number_id": "12345" },
            "messages": [...]
          }
        }
      ]
    }
  ]
}
```

The `WebhookPlug` extracts each `"value"` map from the `"changes"` list and passes it to your handler's `handle_event/1` callback.

## Security Notes

- **Always validate signatures** in production. Never skip verification.
- The SDK uses constant-time comparison (`crypto.hash_equals`) to prevent timing attacks.
- Store your `app_secret` securely (environment variables, not source code).
- The `verify_token` is a shared secret you define — use a strong random value.
