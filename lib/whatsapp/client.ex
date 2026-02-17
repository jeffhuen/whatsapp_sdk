defmodule WhatsApp.Client do
  @moduledoc """
  WhatsApp API client. Holds credentials and executes requests.

  ## Usage

      # From application config (simplest)
      client = WhatsApp.client()

      # Explicit credentials
      client = WhatsApp.client("access_token", phone_number_id: "12345")

      # With options
      client = WhatsApp.client("access_token",
        phone_number_id: "12345",
        business_account_id: "waba_67890",
        api_version: "v23.0",
        max_retries: 3
      )
  """

  alias WhatsApp.Error
  alias WhatsApp.Response
  alias WhatsApp.Telemetry

  @base_url "https://graph.facebook.com"

  @type t :: %__MODULE__{
          access_token: String.t(),
          phone_number_id: String.t() | nil,
          business_account_id: String.t() | nil,
          app_secret: String.t() | nil,
          api_version: String.t(),
          max_retries: non_neg_integer(),
          open_timeout: pos_integer(),
          read_timeout: pos_integer(),
          telemetry_enabled: boolean(),
          finch: atom(),
          user_agent_extensions: [String.t()]
        }

  defstruct [
    :access_token,
    :phone_number_id,
    :business_account_id,
    :app_secret,
    api_version: "v23.0",
    max_retries: 0,
    open_timeout: 30_000,
    read_timeout: 30_000,
    telemetry_enabled: true,
    finch: WhatsApp.Finch,
    user_agent_extensions: []
  ]

  @doc """
  Build a client from application config.

  Reads the `:whatsapp_sdk` application environment for:
  - `:access_token` (required)
  - `:phone_number_id`
  - `:business_account_id`
  - `:app_secret`
  - `:api_version`
  - `:max_retries`
  - `:open_timeout`
  - `:read_timeout`
  - `:finch`
  """
  @spec new() :: t()
  def new do
    config = Application.get_all_env(:whatsapp_sdk)

    opts =
      config
      |> Keyword.take([
        :access_token,
        :phone_number_id,
        :business_account_id,
        :app_secret,
        :api_version,
        :max_retries,
        :open_timeout,
        :read_timeout,
        :telemetry_enabled,
        :finch,
        :user_agent_extensions
      ])

    struct!(__MODULE__, opts)
  end

  @doc """
  Build a client from an explicit access token and options.

  ## Options

  - `:phone_number_id` - WhatsApp phone number ID
  - `:business_account_id` - WhatsApp Business Account ID
  - `:app_secret` - Meta app secret for webhook verification
  - `:api_version` - API version prefix (default: `"v23.0"`)
  - `:max_retries` - Max retry attempts (default: `0`)
  - `:open_timeout` - Connection open timeout in ms (default: `30_000`)
  - `:read_timeout` - Response read timeout in ms (default: `30_000`)
  - `:telemetry_enabled` - Whether to emit telemetry events (default: `true`)
  - `:finch` - Finch instance name (default: `WhatsApp.Finch`)
  - `:user_agent_extensions` - Additional user-agent string segments
  """
  @spec new(String.t(), keyword()) :: t()
  def new(access_token, opts \\ []) do
    opts = Keyword.put(opts, :access_token, access_token)
    struct!(__MODULE__, opts)
  end

  @doc """
  Execute an API request.

  ## Parameters

  - `client` - The client struct
  - `method` - HTTP method (`:get`, `:post`, `:put`, `:delete`, `:patch`)
  - `path` - URL path (e.g., `"/v23.0/12345/messages"`)
  - `opts` - Request options:
    - `:json` - Body to JSON-encode
    - `:multipart` - Multipart form parts (list of Finch multipart tuples)
    - `:form` - Form data to URL-encode
    - `:params` - Query parameters (map or keyword list)
    - `:return_response` - If `true`, return `{:ok, data, %Response{}}` instead of `{:ok, data}`
    - `:base_url` - Override base URL (default: `"https://graph.facebook.com"`)

  ## Returns

  - `{:ok, data}` on success (2xx)
  - `{:ok, data, %Response{}}` on success when `return_response: true`
  - `{:error, %{status: status, body: body}}` on API error (4xx/5xx)
  - `{:error, exception}` on network/transport errors
  """
  @spec request(t(), atom(), String.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), Response.t()} | {:error, term()}
  def request(client, method, path, opts \\ []) do
    base_url = Keyword.get(opts, :base_url, @base_url)
    return_response = Keyword.get(opts, :return_response, false)
    params = Keyword.get(opts, :params)
    max_retries = Keyword.get(opts, :max_retries, client.max_retries)
    request_fn = Keyword.get(opts, :request_fn)

    url = build_url(base_url, path, params)
    headers = build_headers(client, opts)
    {encoded_body, headers} = encode_body(opts, headers)

    maybe_telemetry(client, method, path, fn ->
      execute_with_retries(
        client,
        method,
        path,
        url,
        headers,
        encoded_body,
        return_response,
        max_retries,
        request_fn,
        0
      )
    end)
  end

  @doc """
  Fetch an absolute URL directly (for pagination cursor URLs).

  Pagination cursors from the WhatsApp API return full URLs. This function
  requests those URLs directly without prepending the base URL.

  Accepts the same options as `request/4` except `:base_url`.
  """
  @spec request_url(t(), String.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), Response.t()} | {:error, term()}
  def request_url(client, url, opts \\ []) do
    return_response = Keyword.get(opts, :return_response, false)
    max_retries = Keyword.get(opts, :max_retries, client.max_retries)
    request_fn = Keyword.get(opts, :request_fn)
    headers = build_headers(client, opts)

    maybe_telemetry(client, :get, url, fn ->
      execute_with_retries(
        client,
        :get,
        url,
        url,
        headers,
        nil,
        return_response,
        max_retries,
        request_fn,
        0
      )
    end)
  end

  # ---------------------------------------------------------------------------
  # URL Construction
  # ---------------------------------------------------------------------------

  defp build_url(base_url, path, nil), do: base_url <> path
  defp build_url(base_url, path, params) when params == %{}, do: base_url <> path

  defp build_url(base_url, path, params) when is_list(params) and params == [],
    do: base_url <> path

  defp build_url(base_url, path, params) do
    base_url <> path <> "?" <> URI.encode_query(params)
  end

  # ---------------------------------------------------------------------------
  # Headers
  # ---------------------------------------------------------------------------

  defp build_headers(client, _opts) do
    [
      build_auth_header(client),
      {"user-agent", user_agent(client)},
      {"accept", "application/json"}
    ]
  end

  defp build_auth_header(client) do
    {"authorization", "Bearer #{client.access_token}"}
  end

  defp user_agent(client) do
    base =
      "whatsapp-sdk-elixir/#{WhatsApp.version()} (#{System.otp_release()}) elixir/#{System.version()}"

    case client.user_agent_extensions do
      [] -> base
      exts -> base <> " " <> Enum.join(exts, " ")
    end
  end

  # ---------------------------------------------------------------------------
  # Body Encoding
  # ---------------------------------------------------------------------------

  defp encode_body(opts, headers) do
    cond do
      body = Keyword.get(opts, :json) ->
        encoded = JSON.encode!(body)
        {encoded, [{"content-type", "application/json"} | headers]}

      parts = Keyword.get(opts, :multipart) ->
        # Finch handles multipart encoding; we pass the parts through.
        # The content-type with boundary is set by Finch automatically.
        {{:multipart, parts}, headers}

      form = Keyword.get(opts, :form) ->
        encoded = URI.encode_query(form)
        {encoded, [{"content-type", "application/x-www-form-urlencoded"} | headers]}

      true ->
        {nil, headers}
    end
  end

  # ---------------------------------------------------------------------------
  # Retry Helpers (public for testing, @doc false)
  # ---------------------------------------------------------------------------

  @doc false
  @spec backoff_ms(non_neg_integer()) :: non_neg_integer()
  def backoff_ms(attempt) do
    base = min(round(100 * :math.pow(2, attempt)), 10_000)
    jitter = :rand.uniform(round(base * 0.5) + 1) - 1
    base + jitter
  end

  @doc false
  @spec extract_retry_after([{String.t(), String.t()}]) :: non_neg_integer() | nil
  def extract_retry_after(headers) do
    with value when is_binary(value) <- find_header(headers, "retry-after"),
         {seconds, _rest} <- Integer.parse(value) do
      seconds * 1_000
    else
      _ -> nil
    end
  end

  defp find_header(headers, name) do
    Enum.find_value(headers, fn {key, value} ->
      if String.downcase(key) == name, do: value
    end)
  end

  # ---------------------------------------------------------------------------
  # Retry Loop
  # ---------------------------------------------------------------------------

  defp execute_with_retries(
         client,
         method,
         path,
         url,
         headers,
         body,
         return_response,
         max_retries,
         request_fn,
         attempt
       ) do
    result = do_single_request(client, method, url, headers, body, request_fn)

    case classify_result(result, return_response) do
      {:ok, response} ->
        response

      {:retry, reason, raw_result} when attempt < max_retries ->
        wait_ms = retry_wait_ms(reason, raw_result, attempt)
        Telemetry.emit_retry(method, path, attempt + 1, %{reason: reason, wait_ms: wait_ms})
        Process.sleep(wait_ms)

        execute_with_retries(
          client,
          method,
          path,
          url,
          headers,
          body,
          return_response,
          max_retries,
          request_fn,
          attempt + 1
        )

      {:retry, _reason, raw_result} ->
        finalize_error(raw_result)

      {:error, final_error} ->
        final_error
    end
  end

  defp do_single_request(client, method, url, headers, body, nil) do
    execute_request(client, method, url, headers, body)
  end

  defp do_single_request(_client, method, url, headers, body, request_fn) do
    request_fn.(method, url, headers, body, [])
  end

  defp classify_result(result, return_response) do
    case result do
      {:ok, %Finch.Response{status: status} = finch_resp} when status >= 200 and status < 300 ->
        response = Response.from_finch(finch_resp)
        data = decode_body(finch_resp.body)

        if return_response do
          {:ok, {:ok, data, response}}
        else
          {:ok, {:ok, data}}
        end

      {:ok, %Finch.Response{status: status, body: resp_body, headers: resp_headers}} ->
        body_data = decode_body(resp_body)
        raw = {:api_error, status, body_data, resp_headers}

        if retryable_status?(status, body_data) do
          reason = retry_reason(status, body_data)
          {:retry, reason, raw}
        else
          {:error, finalize_error(raw)}
        end

      {:error, exception} ->
        raw = {:connection_error, exception}
        {:retry, :connection_error, raw}
    end
  end

  defp retryable_status?(429, _body), do: true
  defp retryable_status?(500, _body), do: true
  defp retryable_status?(502, _body), do: true
  defp retryable_status?(503, _body), do: true

  defp retryable_status?(_status, %{"error" => %{"is_transient" => true}}), do: true

  defp retryable_status?(_status, _body), do: false

  defp retry_reason(429, _body), do: :rate_limited
  defp retry_reason(status, _body) when status in [500, 502, 503], do: :server_error

  defp retry_reason(_status, %{"error" => %{"is_transient" => true}}), do: :transient

  defp retry_reason(_status, _body), do: :unknown

  defp retry_wait_ms(
         :rate_limited,
         {:api_error, _status, _body, headers},
         attempt
       ) do
    case extract_retry_after(headers) do
      ms when is_integer(ms) and ms > 0 -> ms
      _ -> backoff_ms(attempt)
    end
  end

  defp retry_wait_ms(_reason, _raw_result, attempt), do: backoff_ms(attempt)

  defp finalize_error({:api_error, status, body_data, headers}) do
    {:error, Error.from_response(status, body_data, headers)}
  end

  defp finalize_error({:connection_error, exception}) do
    {:error, Error.connection_error(exception)}
  end

  # ---------------------------------------------------------------------------
  # HTTP Execution
  # ---------------------------------------------------------------------------

  defp execute_request(client, method, url, headers, body) do
    finch_request = build_finch_request(method, url, headers, body)
    receive_timeout = client.read_timeout
    Finch.request(finch_request, client.finch, receive_timeout: receive_timeout)
  end

  defp build_finch_request(method, url, headers, {:multipart, parts}) do
    boundary = generate_boundary()
    body = encode_multipart_body(parts, boundary)

    headers = [
      {"content-type", "multipart/form-data; boundary=#{boundary}"},
      {"content-length", to_string(byte_size(body))}
      | headers
    ]

    Finch.build(method, url, headers, body)
  end

  defp build_finch_request(method, url, headers, body) do
    Finch.build(method, url, headers, body)
  end

  defp generate_boundary do
    :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
  end

  defp encode_multipart_body(parts, boundary) do
    encoded_parts =
      Enum.map(parts, fn
        {:file, path, name, content_type} ->
          file_content = File.read!(path)
          filename = Path.basename(path)

          "--#{boundary}\r\n" <>
            "content-disposition: form-data; name=\"#{name}\"; filename=\"#{filename}\"\r\n" <>
            "content-type: #{content_type}\r\n" <>
            "\r\n" <>
            file_content <> "\r\n"

        {:file_content, content, name, content_type} ->
          "--#{boundary}\r\n" <>
            "content-disposition: form-data; name=\"#{name}\"; filename=\"#{name}\"\r\n" <>
            "content-type: #{content_type}\r\n" <>
            "\r\n" <>
            content <> "\r\n"

        {name, value} ->
          "--#{boundary}\r\n" <>
            "content-disposition: form-data; name=\"#{name}\"\r\n" <>
            "\r\n" <>
            value <> "\r\n"
      end)

    IO.iodata_to_binary([encoded_parts, "--#{boundary}--\r\n"])
  end

  defp decode_body(""), do: %{}
  defp decode_body(nil), do: %{}

  defp decode_body(body) when is_binary(body) do
    case JSON.decode(body) do
      {:ok, data} -> data
      {:error, _} -> %{"raw" => body}
    end
  end

  # ---------------------------------------------------------------------------
  # Telemetry
  # ---------------------------------------------------------------------------

  defp maybe_telemetry(%{telemetry_enabled: false}, _method, _path, fun) do
    fun.()
  end

  defp maybe_telemetry(_client, method, path, fun) do
    start_time = Telemetry.emit_start(method, path)

    try do
      result = fun.()

      status =
        case result do
          {:ok, _data} -> 200
          {:ok, _data, %Response{status: s}} -> s
          {:error, %Error{status: s}} when is_integer(s) -> s
          {:error, _} -> 0
        end

      Telemetry.emit_stop(start_time, method, path, status)
      result
    rescue
      exception ->
        Telemetry.emit_exception(start_time, method, path, :error, exception)
        reraise exception, __STACKTRACE__
    catch
      kind, reason ->
        Telemetry.emit_exception(start_time, method, path, kind, reason)
        :erlang.raise(kind, reason, __STACKTRACE__)
    end
  end
end
