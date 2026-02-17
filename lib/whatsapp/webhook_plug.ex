defmodule WhatsApp.WebhookPlug do
  @moduledoc """
  Plug for handling WhatsApp webhook requests in Phoenix.

  Handles both subscription verification (GET) and event delivery (POST).

  ## Usage in Phoenix Router

      forward "/webhook/whatsapp", WhatsApp.WebhookPlug,
        app_secret: "your_app_secret",
        verify_token: "your_verify_token",
        handler: MyApp.WhatsAppHandler

  ## Handler Module

      defmodule MyApp.WhatsAppHandler do
        @behaviour WhatsApp.WebhookPlug.Handler

        @impl true
        def handle_event(event) do
          # event is the "value" from each change entry
          :ok
        end
      end

  ## Raw Body Access

  The plug reads the raw request body via `Plug.Conn.read_body/1` for
  signature validation. In a Phoenix application, the body is typically
  consumed by the JSON parser before reaching this plug. To work around
  this, configure a custom body reader that caches the raw body:

      # In your endpoint.ex
      plug Plug.Parsers,
        parsers: [:json],
        pass: ["application/json"],
        body_reader: {MyApp.CacheBodyReader, :read_body, []},
        json_decoder: JSON

  Then this plug will automatically check `conn.assigns[:raw_body]` first
  before falling back to `Plug.Conn.read_body/1`.
  """

  @behaviour Plug

  import Plug.Conn

  @impl true
  @doc """
  Initialize the plug with required options.

  ## Options

    * `:app_secret` (required) - Your Facebook App Secret for signature validation
    * `:verify_token` (required) - The verify token configured in the Meta dashboard
    * `:handler` (required) - A module implementing `WhatsApp.WebhookPlug.Handler`

  Raises `KeyError` if any required option is missing.
  """
  @spec init(keyword()) :: map()
  def init(opts) do
    %{
      app_secret: Keyword.fetch!(opts, :app_secret),
      verify_token: Keyword.fetch!(opts, :verify_token),
      handler: Keyword.fetch!(opts, :handler)
    }
  end

  @impl true
  @doc """
  Handle incoming webhook requests.

  Routes requests based on HTTP method:

    * `GET` - Subscription verification
    * `POST` - Event delivery with signature validation
    * Other methods - Returns 405 Method Not Allowed
  """
  @spec call(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def call(%Plug.Conn{method: "GET"} = conn, config) do
    handle_verification(conn, config)
  end

  def call(%Plug.Conn{method: "POST"} = conn, config) do
    handle_event_delivery(conn, config)
  end

  def call(conn, _config) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(405, "Method Not Allowed")
  end

  # -- Private ----------------------------------------------------------------

  defp handle_verification(conn, config) do
    conn = fetch_query_params(conn)

    case WhatsApp.Webhook.verify_subscription(conn.query_params, config.verify_token) do
      {:ok, challenge} ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, challenge)

      {:error, _error} ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(403, "Verification failed")
    end
  end

  defp handle_event_delivery(conn, config) do
    signature = get_signature_header(conn)
    {raw_body, conn} = read_raw_body(conn)

    if WhatsApp.Webhook.valid?(raw_body, signature, config.app_secret) do
      dispatch_events(raw_body, config.handler)

      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, "OK")
    else
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(403, "Invalid signature")
    end
  end

  defp get_signature_header(conn) do
    case get_req_header(conn, "x-hub-signature-256") do
      [signature | _] -> signature
      [] -> ""
    end
  end

  defp read_raw_body(conn) do
    # Check conn.assigns[:raw_body] first (set by custom body readers in Phoenix),
    # then fall back to Plug.Conn.read_body/1.
    case conn.assigns do
      %{raw_body: raw_body} when is_binary(raw_body) ->
        {raw_body, conn}

      _ ->
        case read_body(conn) do
          {:ok, body, conn} -> {body, conn}
          {:more, _partial, conn} -> {"", conn}
          {:error, _reason} -> {"", conn}
        end
    end
  end

  defp dispatch_events(raw_body, handler) do
    case JSON.decode(raw_body) do
      {:ok, %{"object" => "whatsapp_business_account", "entry" => entries}} ->
        for entry <- entries,
            %{"changes" => changes} <- [entry],
            %{"value" => value} <- changes do
          handler.handle_event(value)
        end

        :ok

      _ ->
        :ok
    end
  end
end
