defmodule WhatsApp.TelemetryTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Telemetry

  describe "event name constants" do
    test "event_start returns correct event name" do
      assert Telemetry.event_start() == [:whatsapp, :request, :start]
    end

    test "event_stop returns correct event name" do
      assert Telemetry.event_stop() == [:whatsapp, :request, :stop]
    end

    test "event_exception returns correct event name" do
      assert Telemetry.event_exception() == [:whatsapp, :request, :exception]
    end

    test "event_retry returns correct event name" do
      assert Telemetry.event_retry() == [:whatsapp, :request, :retry]
    end
  end

  describe "emit_start/2" do
    test "emits start event and returns monotonic start time" do
      ref = make_ref()
      test_pid = self()

      :telemetry.attach(
        "test-start-#{inspect(ref)}",
        [:whatsapp, :request, :start],
        fn event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_event, event, measurements, metadata})
        end,
        nil
      )

      on_exit(fn -> :telemetry.detach("test-start-#{inspect(ref)}") end)

      start_time = Telemetry.emit_start(:post, "/v23.0/12345/messages")

      assert is_integer(start_time)

      assert_receive {:telemetry_event, [:whatsapp, :request, :start], measurements, metadata}
      assert is_integer(measurements.system_time)
      assert metadata.method == :post
      assert metadata.path == "/v23.0/12345/messages"
    end
  end

  describe "emit_stop/4" do
    test "emits stop event with duration" do
      ref = make_ref()
      test_pid = self()

      :telemetry.attach(
        "test-stop-#{inspect(ref)}",
        [:whatsapp, :request, :stop],
        fn event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_event, event, measurements, metadata})
        end,
        nil
      )

      on_exit(fn -> :telemetry.detach("test-stop-#{inspect(ref)}") end)

      start_time = System.monotonic_time()
      Telemetry.emit_stop(start_time, :get, "/v23.0/12345/messages", 200)

      assert_receive {:telemetry_event, [:whatsapp, :request, :stop], measurements, metadata}
      assert is_integer(measurements.duration)
      assert measurements.duration >= 0
      assert metadata.method == :get
      assert metadata.path == "/v23.0/12345/messages"
      assert metadata.status == 200
    end
  end

  describe "emit_exception/5" do
    test "emits exception event with duration and error info" do
      ref = make_ref()
      test_pid = self()

      :telemetry.attach(
        "test-exception-#{inspect(ref)}",
        [:whatsapp, :request, :exception],
        fn event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_event, event, measurements, metadata})
        end,
        nil
      )

      on_exit(fn -> :telemetry.detach("test-exception-#{inspect(ref)}") end)

      start_time = System.monotonic_time()
      reason = %RuntimeError{message: "connection refused"}
      Telemetry.emit_exception(start_time, :post, "/v23.0/12345/messages", :error, reason)

      assert_receive {:telemetry_event, [:whatsapp, :request, :exception], measurements, metadata}
      assert is_integer(measurements.duration)
      assert measurements.duration >= 0
      assert metadata.method == :post
      assert metadata.path == "/v23.0/12345/messages"
      assert metadata.kind == :error
      assert metadata.reason == reason
    end
  end
end
