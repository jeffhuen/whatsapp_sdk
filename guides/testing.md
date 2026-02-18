# Testing

This guide covers writing tests for code that uses the WhatsApp SDK. The SDK ships with `WhatsApp.Test`, a per-process HTTP stub system that supports `async: true` tests.

## Setup

Add the test server to `test/test_helper.exs` (this is already done if you generated the project):

```elixir
WhatsApp.Test.start()
ExUnit.start()
```

## Basic Stubbing

Use `WhatsApp.Test.stub/1` in your test setup to intercept HTTP requests:

```elixir
defmodule MyApp.NotifierTest do
  use ExUnit.Case, async: true

  setup do
    WhatsApp.Test.stub(fn request ->
      case request.url do
        "https://graph.facebook.com/v23.0/" <> _ ->
          %{status: 200, body: ~s({"messages":[{"id":"wamid.123"}]}), headers: []}

        _ ->
          %{status: 404, body: ~s({"error":{"message":"Not found"}}), headers: []}
      end
    end)

    :ok
  end

  test "sends a WhatsApp message" do
    client = WhatsApp.client()
    assert {:ok, %{"messages" => [%{"id" => "wamid.123"}]}} =
      WhatsApp.Client.request(client, :post,
        "/v23.0/#{client.phone_number_id}/messages",
        json: %{"messaging_product" => "whatsapp", "to" => "15551234567", "type" => "text", "text" => %{"body" => "Hello"}}
      )
  end
end
```

## Stub Request Format

The stub function receives a map with:

| Key | Type | Description |
|-----|------|-------------|
| `:method` | atom | HTTP method (`:get`, `:post`, `:put`, `:delete`, `:patch`) |
| `:url` | string | Full request URL |
| `:headers` | list | Header tuples `[{"authorization", "Bearer ..."}, ...]` |
| `:body` | string/nil | Encoded request body |

Return a map with:

| Key | Type | Description |
|-----|------|-------------|
| `:status` | integer | HTTP status code |
| `:body` | string | Response body (JSON string) |
| `:headers` | list | Response header tuples (default: `[]`) |

## Testing Error Handling

Stub error responses to test your error-handling logic:

```elixir
setup do
  WhatsApp.Test.stub(fn _request ->
    %{
      status: 429,
      body: ~s({"error":{"message":"Rate limited","code":80007,"is_transient":true}}),
      headers: [{"retry-after", "60"}]
    }
  end)

  :ok
end

test "handles rate limiting" do
  client = WhatsApp.client()
  assert {:error, %WhatsApp.Error{status: 429, code: 80007}} =
    WhatsApp.Client.request(client, :post, "/v23.0/12345/messages", json: %{})
end
```

## Testing with Spawned Processes

If your code spawns processes (GenServers, Tasks) that make WhatsApp API calls, use `WhatsApp.Test.allow/1` to share the stub:

```elixir
setup do
  WhatsApp.Test.stub(fn _request ->
    %{status: 200, body: ~s({"success":true}), headers: []}
  end)

  {:ok, pid} = MyApp.MessageWorker.start_link()
  WhatsApp.Test.allow(pid)

  %{worker: pid}
end
```

This works because stubs are stored per-process using `NimbleOwnership`. The `allow/1` function grants another process access to the current test process's stub.

## Pattern Matching on Requests

Use pattern matching in your stub to assert on request details:

```elixir
setup do
  test_pid = self()

  WhatsApp.Test.stub(fn request ->
    send(test_pid, {:whatsapp_request, request})
    %{status: 200, body: ~s({"messages":[{"id":"wamid.abc"}]}), headers: []}
  end)

  :ok
end

test "sends correct payload" do
  MyApp.send_welcome_message("15551234567")

  assert_receive {:whatsapp_request, request}
  body = JSON.decode!(request.body)
  assert body["to"] == "15551234567"
  assert body["type"] == "text"
end
```

## Testing Webhooks

Test webhook verification and signature validation directly:

```elixir
test "verifies subscription" do
  params = %{
    "hub.mode" => "subscribe",
    "hub.verify_token" => "my_token",
    "hub.challenge" => "challenge_123"
  }

  assert {:ok, "challenge_123"} = WhatsApp.Webhook.verify_subscription(params, "my_token")
end

test "validates signature" do
  body = ~s({"object":"whatsapp_business_account"})
  secret = "app_secret"
  signature = "sha256=" <> WhatsApp.Webhook.compute_signature(body, secret)

  assert WhatsApp.Webhook.valid?(body, signature, secret)
end
```

## Async Safety

All stubs are process-scoped via `NimbleOwnership`, so `async: true` tests are fully isolated. Each test process gets its own stub, and stubs propagate through the `$callers` chain automatically.

```elixir
use ExUnit.Case, async: true  # Safe with WhatsApp.Test stubs
```

## Tips

- Always stub in `setup` blocks so stubs are registered before test code runs
- Use `assert_receive` with `send/2` in stubs to verify request details
- Return different responses based on `request.url` or `request.method` to simulate complex flows
- For pagination tests, return different cursors/data based on URL query params
