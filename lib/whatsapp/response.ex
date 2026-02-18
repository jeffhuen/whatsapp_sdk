defmodule WhatsApp.Response do
  @moduledoc """
  HTTP response metadata from a WhatsApp Cloud API call.

  Extracts named fields from the response headers defined in the
  OpenAPI spec (`v23.0`). Raw headers are also preserved for any additional values.

  ## Named Header Fields

  | Response Header | Struct Field | Description (from OpenAPI spec) |
  |---|---|---|
  | `x-fb-trace-id` | `trace_id` | Facebook trace identifier for request tracking |
  | `x-fb-request-id` | `request_id` | Unique identifier for the request for debugging purposes |
  | `X-FB-Debug` | `debug` | Facebook debug information for troubleshooting |
  | `facebook-api-version` | `api_version` | Facebook Graph API version used for the request |
  | `x-business-use-case-usage` | `business_use_case_usage` | Business use case usage metrics and rate limiting information (parsed JSON) |
  | `x-app-usage` | `app_usage` | Application usage metrics (parsed JSON) |
  | `x-fb-rlafr` | `rate_limit_status` | Facebook rate limiting and feature restriction status |
  | `X-FB-Connection-Quality` | `connection_quality` | Facebook connection quality metrics |
  | `x-fb-rev` | `rev` | Facebook internal revision number |
  """

  @type t :: %__MODULE__{
          status: non_neg_integer(),
          headers: [{String.t(), String.t()}],
          trace_id: String.t() | nil,
          request_id: String.t() | nil,
          debug: String.t() | nil,
          api_version: String.t() | nil,
          business_use_case_usage: map() | nil,
          app_usage: map() | nil,
          rate_limit_status: String.t() | nil,
          connection_quality: String.t() | nil,
          rev: String.t() | nil
        }

  defstruct [
    :status,
    :trace_id,
    :request_id,
    :debug,
    :api_version,
    :business_use_case_usage,
    :app_usage,
    :rate_limit_status,
    :connection_quality,
    :rev,
    headers: []
  ]

  @doc """
  Build a Response from HTTP status and headers.

  Extracts named header fields and parses JSON-encoded headers
  (`x-business-use-case-usage`, `x-app-usage`) into maps.
  """
  @spec from_fields(non_neg_integer(), [{String.t(), String.t()}]) :: t()
  def from_fields(status, headers) do
    %__MODULE__{
      status: status,
      headers: headers,
      trace_id: get_header(headers, "x-fb-trace-id"),
      request_id: get_header(headers, "x-fb-request-id"),
      debug: get_header(headers, "x-fb-debug"),
      api_version: get_header(headers, "facebook-api-version"),
      business_use_case_usage: headers |> get_header("x-business-use-case-usage") |> parse_json(),
      app_usage: headers |> get_header("x-app-usage") |> parse_json(),
      rate_limit_status: get_header(headers, "x-fb-rlafr"),
      connection_quality: get_header(headers, "x-fb-connection-quality"),
      rev: get_header(headers, "x-fb-rev")
    }
  end

  defp get_header(headers, name) do
    Enum.find_value(headers, fn {key, value} ->
      if String.downcase(key) == name, do: value
    end)
  end

  defp parse_json(nil), do: nil

  defp parse_json(str) do
    case JSON.decode(str) do
      {:ok, map} -> map
      _ -> nil
    end
  end
end
