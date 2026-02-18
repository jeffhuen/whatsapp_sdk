defmodule WhatsApp.Resources.BlockedUser do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `messaging_product` | `String.t()` |  |
  | `wa_id` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          messaging_product: String.t() | nil,
          wa_id: String.t() | nil
        }
  defstruct [
    :messaging_product,
    :wa_id
  ]
end
