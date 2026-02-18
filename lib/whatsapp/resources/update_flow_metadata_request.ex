defmodule WhatsApp.Resources.UpdateFlowMetadataRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `categories` | `String.t()` |  |
  | `endpoint_uri` | `String.t()` |  |
  | `name` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          categories: String.t() | nil,
          endpoint_uri: String.t() | nil,
          name: String.t() | nil
        }
  defstruct [
    :categories,
    :endpoint_uri,
    :name
  ]
end
