defmodule WhatsApp.Error do
  @moduledoc """
  WhatsApp API error.

  Represents both API errors (4xx/5xx responses with Meta error bodies)
  and connection-level errors (network failures, timeouts).

  This module implements the `Exception` behaviour so errors can be raised
  when desired, but are typically returned in `{:error, %WhatsApp.Error{}}`
  tuples.

  ## Meta Error Format

  Meta's Graph API returns errors in a consistent format:

      %{
        "error" => %{
          "message" => "Invalid OAuth access token...",
          "type" => "OAuthException",
          "code" => 190,
          "error_subcode" => 463,
          "fbtrace_id" => "AbC123dEf456",
          "is_transient" => false
        }
      }

  ## Usage

      case WhatsApp.Messages.send(client, params) do
        {:ok, message} ->
          message

        {:error, %WhatsApp.Error{code: 190}} ->
          Logger.error("Invalid access token")

        {:error, %WhatsApp.Error{status: 429, retry_after: seconds}} ->
          Process.sleep(seconds * 1_000)

        {:error, %WhatsApp.Error{} = err} ->
          Logger.error("WhatsApp error \#{err.code}: \#{err.message}")
      end
  """

  defexception [
    :message,
    :status,
    :code,
    :error_subcode,
    :error_type,
    :fbtrace_id,
    :retry_after,
    :details,
    is_transient: false
  ]

  @type t :: %__MODULE__{
          message: String.t(),
          status: integer() | nil,
          code: integer() | nil,
          error_subcode: integer() | nil,
          error_type: String.t() | nil,
          fbtrace_id: String.t() | nil,
          is_transient: boolean(),
          retry_after: integer() | nil,
          details: map() | nil
        }

  @doc """
  Build an error from an HTTP status code and a decoded response body.

  Handles Meta's standard error format where the error details are nested
  under an `"error"` key, as well as responses that don't follow this format.

  ## Examples

      iex> body = %{"error" => %{"message" => "Invalid token", "type" => "OAuthException", "code" => 190}}
      iex> error = WhatsApp.Error.from_response(401, body)
      iex> error.code
      190

  """
  @spec from_response(integer(), map()) :: t()
  def from_response(status, body) do
    from_response(status, body, [])
  end

  @doc """
  Build an error from an HTTP status code, decoded response body, and response headers.

  The headers list is inspected for a `Retry-After` header, which is parsed
  as an integer number of seconds.

  ## Examples

      iex> body = %{"error" => %{"message" => "Rate limited", "code" => 80007}}
      iex> headers = [{"retry-after", "60"}]
      iex> error = WhatsApp.Error.from_response(429, body, headers)
      iex> error.retry_after
      60

  """
  @spec from_response(integer(), map(), list()) :: t()
  def from_response(status, %{"error" => error_data} = body, headers) when is_map(error_data) do
    %__MODULE__{
      message: error_data["message"] || "HTTP #{status}",
      status: status,
      code: error_data["code"],
      error_subcode: error_data["error_subcode"],
      error_type: error_data["type"],
      fbtrace_id: error_data["fbtrace_id"],
      is_transient: error_data["is_transient"] || false,
      retry_after: parse_retry_after(headers),
      details: body
    }
  end

  def from_response(status, body, headers) when is_map(body) do
    %__MODULE__{
      message: body["message"] || "HTTP #{status}",
      status: status,
      is_transient: false,
      retry_after: parse_retry_after(headers),
      details: body
    }
  end

  @doc """
  Build a connection-level error from a transport error or reason.

  Used for network failures, timeouts, and other connection issues
  where no HTTP response was received.

  ## Examples

      iex> error = WhatsApp.Error.connection_error(%Mint.TransportError{reason: :timeout})
      iex> error.message
      "timeout"

      iex> error = WhatsApp.Error.connection_error("connection refused")
      iex> error.message
      "connection refused"

  """
  @spec connection_error(Exception.t() | String.t()) :: t()
  def connection_error(%{__exception__: true} = exception) do
    %__MODULE__{
      message: Exception.message(exception),
      is_transient: false
    }
  end

  def connection_error(reason) when is_binary(reason) do
    %__MODULE__{
      message: reason,
      is_transient: false
    }
  end

  def connection_error(reason) do
    %__MODULE__{
      message: inspect(reason),
      is_transient: false
    }
  end

  @doc """
  Build an error for webhook verification failures.

  ## Examples

      iex> error = WhatsApp.Error.webhook_verification_error("token mismatch")
      iex> error.message
      "Webhook verification failed: token mismatch"

  """
  @spec webhook_verification_error(String.t()) :: t()
  def webhook_verification_error(reason) when is_binary(reason) do
    %__MODULE__{
      message: "Webhook verification failed: #{reason}",
      is_transient: false
    }
  end

  @doc """
  Returns whether the error is retryable.

  The following errors are considered retryable:

  - Rate limit errors (HTTP 429)
  - Server errors (HTTP 500, 502, 503)
  - Connection errors (no HTTP status code)
  - Errors explicitly marked as transient by Meta (`is_transient: true`)

  ## Examples

      iex> WhatsApp.Error.retryable?(%WhatsApp.Error{message: "rate limited", status: 429})
      true

      iex> WhatsApp.Error.retryable?(%WhatsApp.Error{message: "not found", status: 404})
      false

  """
  @spec retryable?(t()) :: boolean()
  def retryable?(%__MODULE__{status: 429}), do: true
  def retryable?(%__MODULE__{status: 500}), do: true
  def retryable?(%__MODULE__{status: 502}), do: true
  def retryable?(%__MODULE__{status: 503}), do: true
  def retryable?(%__MODULE__{is_transient: true}), do: true
  def retryable?(%__MODULE__{status: nil}), do: true
  def retryable?(%__MODULE__{}), do: false

  @doc """
  Returns the human-readable error message.

  ## Examples

      iex> WhatsApp.Error.message(%WhatsApp.Error{message: "Invalid token"})
      "Invalid token"

  """
  @spec message(t()) :: String.t()
  def message(%__MODULE__{message: message}), do: message

  # -- Private helpers --------------------------------------------------------

  defp parse_retry_after(headers) do
    with value when is_binary(value) <- get_header(headers, "retry-after"),
         {seconds, _rest} <- Integer.parse(value) do
      seconds
    else
      _ -> nil
    end
  end

  defp get_header(headers, name) do
    Enum.find_value(headers, fn {key, value} ->
      if String.downcase(key) == name, do: value
    end)
  end
end
