defmodule WhatsApp.Resources.UploadImageRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `file` | `String.t()` |  |
  | `messaging_product` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          file: String.t() | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :file,
    :messaging_product
  ]
end
