defmodule WhatsApp.Resources.RetrieveMediaUrl do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `file_size` | `String.t()` |  |
  | `id` | `String.t()` |  |
  | `messaging_product` | `String.t()` |  |
  | `mime_type` | `String.t()` |  |
  | `sha256` | `String.t()` |  |
  | `url` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          file_size: String.t() | nil,
          id: String.t() | nil,
          messaging_product: String.t() | nil,
          mime_type: String.t() | nil,
          sha256: String.t() | nil,
          url: String.t() | nil
        }
  defstruct [
    :file_size,
    :id,
    :messaging_product,
    :mime_type,
    :sha256,
    :url
  ]
end
