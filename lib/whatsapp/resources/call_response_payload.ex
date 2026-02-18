defmodule WhatsApp.Resources.CallResponsePayload do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `calls` | `list()` |  |
  | `messaging_product` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          calls: list(map()) | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :calls,
    :messaging_product
  ]
end
