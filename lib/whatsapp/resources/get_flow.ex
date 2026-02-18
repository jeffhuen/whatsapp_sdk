defmodule WhatsApp.Resources.GetFlow do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `application` | `map()` |  |
  | `categories` | `list()` |  |
  | `data_api_version` | `String.t()` |  |
  | `data_channel_uri` | `String.t()` |  |
  | `health_status` | `map()` |  |
  | `id` | `String.t()` |  |
  | `json_version` | `String.t()` |  |
  | `metric` | `map()` |  |
  | `name` | `String.t()` |  |
  | `preview` | `map()` |  |
  | `status` | `String.t()` |  |
  | `validation_errors` | `list()` |  |
  | `whatsapp_business_account` | `map()` |  |
  """

  @type t :: %__MODULE__{
          application: map() | nil,
          categories: list(String.t()) | nil,
          data_api_version: String.t() | nil,
          data_channel_uri: String.t() | nil,
          health_status: map() | nil,
          id: String.t() | nil,
          json_version: String.t() | nil,
          metric: map() | nil,
          name: String.t() | nil,
          preview: map() | nil,
          status: String.t() | nil,
          validation_errors: list(term()) | nil,
          whatsapp_business_account: map() | nil
        }
  defstruct [
    :application,
    :categories,
    :data_api_version,
    :data_channel_uri,
    :health_status,
    :id,
    :json_version,
    :metric,
    :name,
    :preview,
    :status,
    :validation_errors,
    :whatsapp_business_account
  ]
end
