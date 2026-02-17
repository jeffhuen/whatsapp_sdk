defmodule WhatsApp.Telemetry do
  @moduledoc """
  Telemetry event helpers for WhatsApp API requests.

  ## Events

  | Event | Measurements | Metadata |
  |-------|-------------|----------|
  | `[:whatsapp, :request, :start]` | `%{system_time: integer}` | `%{method: atom, path: String.t}` |
  | `[:whatsapp, :request, :stop]` | `%{duration: integer}` | `%{method: atom, path: String.t, status: integer}` |
  | `[:whatsapp, :request, :exception]` | `%{duration: integer}` | `%{method: atom, path: String.t, kind: atom, reason: term}` |
  | `[:whatsapp, :request, :retry]` | `%{system_time: integer}` | `%{method: atom, path: String.t, attempt: integer, reason: term, wait_ms: integer}` |

  ## Attaching Handlers

      :telemetry.attach_many(
        "whatsapp-logger",
        [
          [:whatsapp, :request, :start],
          [:whatsapp, :request, :stop],
          [:whatsapp, :request, :exception]
        ],
        &MyApp.TelemetryHandler.handle_event/4,
        nil
      )
  """

  @event_start [:whatsapp, :request, :start]
  @event_stop [:whatsapp, :request, :stop]
  @event_exception [:whatsapp, :request, :exception]
  @event_retry [:whatsapp, :request, :retry]

  @doc "Returns the `[:whatsapp, :request, :start]` event name."
  @spec event_start() :: [atom()]
  def event_start, do: @event_start

  @doc "Returns the `[:whatsapp, :request, :stop]` event name."
  @spec event_stop() :: [atom()]
  def event_stop, do: @event_stop

  @doc "Returns the `[:whatsapp, :request, :exception]` event name."
  @spec event_exception() :: [atom()]
  def event_exception, do: @event_exception

  @doc "Returns the `[:whatsapp, :request, :retry]` event name."
  @spec event_retry() :: [atom()]
  def event_retry, do: @event_retry

  @doc """
  Emit a `:start` telemetry event.

  Returns the start time (monotonic) for computing duration in stop/exception.
  """
  @spec emit_start(atom(), String.t()) :: integer()
  def emit_start(method, path) do
    start_time = System.monotonic_time()

    :telemetry.execute(@event_start, %{system_time: System.system_time()}, %{
      method: method,
      path: path
    })

    start_time
  end

  @doc """
  Emit a `:stop` telemetry event.

  `start_time` is the monotonic time returned by `emit_start/2`.
  """
  @spec emit_stop(integer(), atom(), String.t(), integer()) :: :ok
  def emit_stop(start_time, method, path, status) do
    duration = System.monotonic_time() - start_time

    :telemetry.execute(@event_stop, %{duration: duration}, %{
      method: method,
      path: path,
      status: status
    })
  end

  @doc """
  Emit a `:retry` telemetry event.

  Called before each retry attempt to allow observability into retry behaviour.

  - `method` - HTTP method atom
  - `path` - request path string
  - `attempt` - the upcoming attempt number (1-indexed, so first retry is attempt 2)
  - `metadata` - map with `:reason` (atom) and `:wait_ms` (integer)
  """
  @spec emit_retry(atom(), String.t(), pos_integer(), map()) :: :ok
  def emit_retry(method, path, attempt, %{reason: _reason, wait_ms: _wait_ms} = metadata) do
    :telemetry.execute(@event_retry, %{system_time: System.system_time()}, %{
      method: method,
      path: path,
      attempt: attempt,
      reason: metadata.reason,
      wait_ms: metadata.wait_ms
    })
  end

  @doc """
  Emit an `:exception` telemetry event.

  `start_time` is the monotonic time returned by `emit_start/2`.
  """
  @spec emit_exception(integer(), atom(), String.t(), atom(), term()) :: :ok
  def emit_exception(start_time, method, path, kind, reason) do
    duration = System.monotonic_time() - start_time

    :telemetry.execute(@event_exception, %{duration: duration}, %{
      method: method,
      path: path,
      kind: kind,
      reason: reason
    })
  end
end
