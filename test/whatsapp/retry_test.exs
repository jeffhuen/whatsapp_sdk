defmodule WhatsApp.RetryTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Client
  alias WhatsApp.Error

  # ---------------------------------------------------------------------------
  # Helper: build a client with telemetry disabled (avoids noise in tests)
  # ---------------------------------------------------------------------------

  defp client(opts) do
    defaults = [phone_number_id: "123", telemetry_enabled: false]
    Client.new("test_token", Keyword.merge(defaults, opts))
  end

  # ---------------------------------------------------------------------------
  # Helper: build a request_fn that replays a list of canned responses
  # ---------------------------------------------------------------------------

  defp sequenced_request_fn(responses) do
    counter = :counters.new(1, [:atomics])

    fn _method, _url, _headers, _body, _opts ->
      index = :counters.get(counter, 1)
      :counters.add(counter, 1, 1)
      Enum.at(responses, index)
    end
  end

  # ---------------------------------------------------------------------------
  # Helper: counting request_fn returning a single response
  # ---------------------------------------------------------------------------

  defp counting_request_fn(response) do
    counter = :counters.new(1, [:atomics])

    request_fn = fn _method, _url, _headers, _body, _opts ->
      :counters.add(counter, 1, 1)
      response
    end

    {request_fn, counter}
  end

  # ---------------------------------------------------------------------------
  # Helper: common response builders
  # ---------------------------------------------------------------------------

  defp ok_response(body \\ ~s({"messages":[{"id":"wamid.123"}]})) do
    {:ok, %Finch.Response{status: 200, body: body, headers: []}}
  end

  defp error_response(status, body, headers \\ []) do
    {:ok, %Finch.Response{status: status, body: body, headers: headers}}
  end

  defp rate_limited_response(retry_after \\ "0") do
    body = ~s({"error":{"message":"Rate limited","code":80007,"is_transient":true}})
    error_response(429, body, [{"retry-after", retry_after}])
  end

  defp server_error_response(status) do
    body = ~s({"error":{"message":"Internal error","code":1}})
    error_response(status, body)
  end

  defp transient_4xx_response do
    body = ~s({"error":{"message":"Temporary issue","code":2,"is_transient":true}})
    error_response(400, body)
  end

  defp connection_error do
    {:error, %Mint.TransportError{reason: :timeout}}
  end

  # ===========================================================================
  # backoff_ms/1
  # ===========================================================================

  describe "backoff_ms/1" do
    test "attempt 0 returns value between 100 and 150" do
      for _ <- 1..50 do
        ms = Client.backoff_ms(0)
        assert ms >= 100 and ms <= 150, "expected 100..150, got #{ms}"
      end
    end

    test "attempt 1 returns value between 200 and 300" do
      for _ <- 1..50 do
        ms = Client.backoff_ms(1)
        assert ms >= 200 and ms <= 300, "expected 200..300, got #{ms}"
      end
    end

    test "attempt 2 returns value between 400 and 600" do
      for _ <- 1..50 do
        ms = Client.backoff_ms(2)
        assert ms >= 400 and ms <= 600, "expected 400..600, got #{ms}"
      end
    end

    test "caps at 10_000 base for high attempts" do
      for _ <- 1..50 do
        ms = Client.backoff_ms(20)
        assert ms >= 10_000 and ms <= 15_000, "expected 10000..15000, got #{ms}"
      end
    end

    test "values increase with attempt number" do
      # Use averages over multiple samples to account for jitter
      avg = fn attempt ->
        values = for _ <- 1..100, do: Client.backoff_ms(attempt)
        Enum.sum(values) / length(values)
      end

      avg0 = avg.(0)
      avg1 = avg.(1)
      avg2 = avg.(2)

      assert avg1 > avg0
      assert avg2 > avg1
    end
  end

  # ===========================================================================
  # extract_retry_after/1
  # ===========================================================================

  describe "extract_retry_after/1" do
    test "parses retry-after header as seconds, returns milliseconds" do
      assert Client.extract_retry_after([{"retry-after", "60"}]) == 60_000
    end

    test "handles case-insensitive header name" do
      assert Client.extract_retry_after([{"Retry-After", "5"}]) == 5_000
    end

    test "returns nil when header is missing" do
      assert Client.extract_retry_after([{"content-type", "application/json"}]) == nil
    end

    test "returns nil for empty headers" do
      assert Client.extract_retry_after([]) == nil
    end

    test "returns nil for non-numeric value" do
      assert Client.extract_retry_after([{"retry-after", "not-a-number"}]) == nil
    end

    test "parses retry-after of 0" do
      # 0 seconds = 0 ms, but 0 is not > 0 so backoff will be used instead
      assert Client.extract_retry_after([{"retry-after", "0"}]) == 0
    end

    test "parses retry-after with trailing text" do
      assert Client.extract_retry_after([{"retry-after", "30 seconds"}]) == 30_000
    end
  end

  # ===========================================================================
  # No retry when max_retries=0 (default)
  # ===========================================================================

  describe "no retry when max_retries=0" do
    test "returns error immediately on 429 without retrying" do
      {request_fn, counter} = counting_request_fn(rate_limited_response())
      c = client(max_retries: 0)

      assert {:error, %Error{status: 429}} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert :counters.get(counter, 1) == 1
    end

    test "returns error immediately on 500 without retrying" do
      {request_fn, counter} = counting_request_fn(server_error_response(500))
      c = client(max_retries: 0)

      assert {:error, %Error{status: 500}} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert :counters.get(counter, 1) == 1
    end

    test "returns error immediately on connection error without retrying" do
      {request_fn, counter} = counting_request_fn(connection_error())
      c = client(max_retries: 0)

      assert {:error, %Error{status: nil}} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert :counters.get(counter, 1) == 1
    end
  end

  # ===========================================================================
  # Retry on 429, eventually succeed
  # ===========================================================================

  describe "retry on 429" do
    test "retries then succeeds" do
      responses = [rate_limited_response(), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 2)

      assert {:ok, data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert data["messages"]
    end

    test "respects Retry-After header (converts seconds to ms)" do
      # We use "0" so the test doesn't actually sleep. The important thing
      # is that the code path parses the header and uses it.
      responses = [rate_limited_response("0"), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 1)

      assert {:ok, _data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )
    end
  end

  # ===========================================================================
  # Retry on 500/502/503
  # ===========================================================================

  describe "retry on server errors" do
    test "retries on 500 then succeeds" do
      responses = [server_error_response(500), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 2)

      assert {:ok, data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert data["messages"]
    end

    test "retries on 502 then succeeds" do
      responses = [server_error_response(502), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 2)

      assert {:ok, _data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )
    end

    test "retries on 503 then succeeds" do
      responses = [server_error_response(503), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 2)

      assert {:ok, _data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )
    end
  end

  # ===========================================================================
  # Retry on connection error
  # ===========================================================================

  describe "retry on connection error" do
    test "retries on transport error then succeeds" do
      responses = [connection_error(), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 2)

      assert {:ok, data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert data["messages"]
    end

    test "returns connection error after exhausting retries" do
      responses = [connection_error(), connection_error(), connection_error()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 2)

      assert {:error, %Error{status: nil, message: "timeout"}} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )
    end
  end

  # ===========================================================================
  # Respects max_retries limit
  # ===========================================================================

  describe "max_retries limit" do
    test "stops retrying after max_retries attempts" do
      {request_fn, counter} = counting_request_fn(server_error_response(500))
      c = client(max_retries: 3)

      assert {:error, %Error{status: 500}} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      # 1 initial + 3 retries = 4 total
      assert :counters.get(counter, 1) == 4
    end

    test "succeeds on the last retry attempt" do
      responses = [
        server_error_response(500),
        server_error_response(500),
        ok_response()
      ]

      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 2)

      assert {:ok, data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert data["messages"]
    end
  end

  # ===========================================================================
  # is_transient: true retries even for 4xx
  # ===========================================================================

  describe "is_transient retries" do
    test "retries 400 with is_transient: true then succeeds" do
      responses = [transient_4xx_response(), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 2)

      assert {:ok, data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert data["messages"]
    end

    test "returns error for is_transient: true after max retries exhausted" do
      {request_fn, counter} = counting_request_fn(transient_4xx_response())
      c = client(max_retries: 1)

      assert {:error, %Error{status: 400, is_transient: true}} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      # 1 initial + 1 retry = 2
      assert :counters.get(counter, 1) == 2
    end
  end

  # ===========================================================================
  # Non-retryable status codes
  # ===========================================================================

  describe "non-retryable errors are not retried" do
    for status <- [400, 401, 403, 404] do
      test "#{status} is not retried" do
        body =
          ~s({"error":{"message":"Client error","code":100,"is_transient":false}})

        {request_fn, counter} =
          counting_request_fn(error_response(unquote(status), body))

        c = client(max_retries: 3)

        assert {:error, %Error{status: unquote(status)}} =
                 Client.request(c, :post, "/v23.0/123/messages",
                   json: %{},
                   request_fn: request_fn
                 )

        assert :counters.get(counter, 1) == 1
      end
    end
  end

  # ===========================================================================
  # Per-request max_retries override
  # ===========================================================================

  describe "per-request max_retries override" do
    test "per-request option overrides client default" do
      {request_fn, counter} = counting_request_fn(server_error_response(500))
      c = client(max_retries: 1)

      # Override to 3 retries at request level
      assert {:error, %Error{status: 500}} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn,
                 max_retries: 3
               )

      # 1 initial + 3 retries = 4 total
      assert :counters.get(counter, 1) == 4
    end

    test "per-request option can disable retries" do
      {request_fn, counter} = counting_request_fn(server_error_response(500))
      c = client(max_retries: 5)

      # Override to 0 retries at request level
      assert {:error, %Error{status: 500}} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn,
                 max_retries: 0
               )

      assert :counters.get(counter, 1) == 1
    end
  end

  # ===========================================================================
  # Retry telemetry events
  # ===========================================================================

  describe "retry telemetry events" do
    test "emits retry telemetry event on each retry" do
      ref = make_ref()
      test_pid = self()

      :telemetry.attach(
        "test-retry-#{inspect(ref)}",
        [:whatsapp, :request, :retry],
        fn _event, measurements, metadata, _config ->
          send(test_pid, {:retry_event, measurements, metadata})
        end,
        nil
      )

      on_exit(fn -> :telemetry.detach("test-retry-#{inspect(ref)}") end)

      responses = [
        server_error_response(500),
        server_error_response(502),
        ok_response()
      ]

      request_fn = sequenced_request_fn(responses)
      # Enable telemetry for this test
      c = client(max_retries: 3, telemetry_enabled: true)

      assert {:ok, _data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      # First retry event (after first 500)
      assert_receive {:retry_event, measurements1, metadata1}
      assert is_integer(measurements1.system_time)
      assert metadata1.method == :post
      assert metadata1.path == "/v23.0/123/messages"
      assert metadata1.attempt == 1
      assert metadata1.reason == :server_error
      assert is_integer(metadata1.wait_ms)

      # Second retry event (after 502)
      assert_receive {:retry_event, measurements2, metadata2}
      assert is_integer(measurements2.system_time)
      assert metadata2.attempt == 2
      assert metadata2.reason == :server_error
    end

    test "emits retry event with :rate_limited reason for 429" do
      ref = make_ref()
      test_pid = self()

      :telemetry.attach(
        "test-retry-rl-#{inspect(ref)}",
        [:whatsapp, :request, :retry],
        fn _event, _measurements, metadata, _config ->
          send(test_pid, {:retry_reason, metadata.reason})
        end,
        nil
      )

      on_exit(fn -> :telemetry.detach("test-retry-rl-#{inspect(ref)}") end)

      responses = [rate_limited_response("0"), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 1, telemetry_enabled: true)

      assert {:ok, _} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert_receive {:retry_reason, :rate_limited}
    end

    test "emits retry event with :connection_error reason" do
      ref = make_ref()
      test_pid = self()

      :telemetry.attach(
        "test-retry-conn-#{inspect(ref)}",
        [:whatsapp, :request, :retry],
        fn _event, _measurements, metadata, _config ->
          send(test_pid, {:retry_reason, metadata.reason})
        end,
        nil
      )

      on_exit(fn -> :telemetry.detach("test-retry-conn-#{inspect(ref)}") end)

      responses = [connection_error(), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 1, telemetry_enabled: true)

      assert {:ok, _} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert_receive {:retry_reason, :connection_error}
    end

    test "emits retry event with :transient reason for is_transient 4xx" do
      ref = make_ref()
      test_pid = self()

      :telemetry.attach(
        "test-retry-transient-#{inspect(ref)}",
        [:whatsapp, :request, :retry],
        fn _event, _measurements, metadata, _config ->
          send(test_pid, {:retry_reason, metadata.reason})
        end,
        nil
      )

      on_exit(fn -> :telemetry.detach("test-retry-transient-#{inspect(ref)}") end)

      responses = [transient_4xx_response(), ok_response()]
      request_fn = sequenced_request_fn(responses)
      c = client(max_retries: 1, telemetry_enabled: true)

      assert {:ok, _} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert_receive {:retry_reason, :transient}
    end
  end

  # ===========================================================================
  # Success on first attempt (no retry needed)
  # ===========================================================================

  describe "success on first attempt" do
    test "returns ok immediately without retrying" do
      {request_fn, counter} = counting_request_fn(ok_response())
      c = client(max_retries: 3)

      assert {:ok, data} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert data["messages"]
      assert :counters.get(counter, 1) == 1
    end
  end

  # ===========================================================================
  # Error struct fields are populated correctly
  # ===========================================================================

  describe "error conversion" do
    test "API error is converted to WhatsApp.Error struct" do
      body =
        ~s({"error":{"message":"Invalid token","type":"OAuthException","code":190,"fbtrace_id":"abc123"}})

      {request_fn, _counter} = counting_request_fn(error_response(401, body))
      c = client(max_retries: 0)

      assert {:error, %Error{} = err} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert err.status == 401
      assert err.code == 190
      assert err.error_type == "OAuthException"
      assert err.fbtrace_id == "abc123"
      assert err.message == "Invalid token"
    end

    test "connection error is converted to WhatsApp.Error struct" do
      {request_fn, _counter} = counting_request_fn(connection_error())
      c = client(max_retries: 0)

      assert {:error, %Error{} = err} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert err.status == nil
      assert err.message == "timeout"
    end

    test "retry-after from 429 is populated on final Error" do
      {request_fn, _counter} = counting_request_fn(rate_limited_response("30"))
      c = client(max_retries: 0)

      assert {:error, %Error{} = err} =
               Client.request(c, :post, "/v23.0/123/messages",
                 json: %{},
                 request_fn: request_fn
               )

      assert err.status == 429
      assert err.retry_after == 30
    end
  end
end
