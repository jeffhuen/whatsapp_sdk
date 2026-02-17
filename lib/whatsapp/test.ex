defmodule WhatsApp.Test do
  @moduledoc """
  Test helpers for WhatsApp SDK.

  Provides process-scoped HTTP stubs via `NimbleOwnership` for writing
  `async: true` tests without hitting the real API.

  ## Setup

      # In test/test_helper.exs
      WhatsApp.Test.start()
      ExUnit.start()

  ## Usage

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

        test "sends a message" do
          client = WhatsApp.client()
          assert {:ok, _} = MyApp.send_whatsapp(client, "Hello!")
        end
      end

  ## How It Works

  Each test process registers a stub function via `stub/1`. The stub is stored
  as metadata in a `NimbleOwnership` server, keyed by the `:http_stub` atom.

  When the SDK makes an HTTP request, it calls `fetch_fun/0` to check whether
  a stub exists for the current process (or any process in the `$callers` chain).
  If a stub is found, the request is routed through the stub function instead
  of Finch.

  Because stubs are process-scoped, tests using `async: true` are fully isolated
  from one another.
  """

  @ownership_server __MODULE__
  @key :http_stub

  @doc """
  Start the test stub ownership server.

  Call this in `test/test_helper.exs` before `ExUnit.start()`.
  """
  @spec start() :: {:ok, pid()} | {:error, term()}
  def start do
    NimbleOwnership.start_link(name: @ownership_server)
  end

  @doc """
  Register a stub function for the current test process.

  The function receives a request map with:

    * `:method` - HTTP method atom (`:get`, `:post`, etc.)
    * `:url` - Full request URL string
    * `:headers` - List of `{name, value}` header tuples
    * `:body` - Request body (string, nil, or `{:multipart, parts}`)

  It must return a response map with:

    * `:status` - HTTP status code integer
    * `:body` - Response body string
    * `:headers` - List of `{name, value}` header tuples (default: `[]`)

  ## Example

      WhatsApp.Test.stub(fn _request ->
        %{status: 200, body: ~s({"success":true}), headers: []}
      end)
  """
  @spec stub((map() -> map())) :: :ok
  def stub(fun) when is_function(fun, 1) do
    case NimbleOwnership.get_and_update(@ownership_server, self(), @key, fn _existing ->
           {:ok, fun}
         end) do
      {:ok, :ok} -> :ok
      {:error, reason} -> raise "Failed to register stub: #{inspect(reason)}"
    end
  end

  # Retrieve the stub function for the current process (or its callers chain).
  # Returns `{:ok, fun}` if a stub is registered, `:error` otherwise.
  # This is called internally by the Client to check for stubs before
  # making real HTTP calls.
  @doc false
  @spec fetch_fun() :: {:ok, (map() -> map())} | :error
  def fetch_fun do
    case NimbleOwnership.fetch_owner(@ownership_server, callers(), @key) do
      {:ok, owner_pid} ->
        case NimbleOwnership.get_and_update(@ownership_server, owner_pid, @key, fn fun ->
               {fun, fun}
             end) do
          {:ok, fun} when is_function(fun, 1) -> {:ok, fun}
          _ -> :error
        end

      :error ->
        :error
    end
  end

  @doc """
  Allow another process to use the current process's stub.

  Useful when your test spawns a process (like a GenServer) that
  needs to use the same stub as the test process.

  ## Example

      setup do
        WhatsApp.Test.stub(fn _request ->
          %{status: 200, body: "{}", headers: []}
        end)

        {:ok, pid} = MyWorker.start_link()
        WhatsApp.Test.allow(pid)
        %{worker: pid}
      end
  """
  @spec allow(pid()) :: :ok
  def allow(pid) when is_pid(pid) do
    case NimbleOwnership.allow(@ownership_server, self(), pid, @key) do
      :ok -> :ok
      {:error, reason} -> raise "Failed to allow process: #{inspect(reason)}"
    end
  end

  defp callers do
    [self() | Process.get(:"$callers", [])]
  end
end
