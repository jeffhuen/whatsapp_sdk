defmodule WhatsApp.Resources.BlockedUser do
  @moduledoc false

  @type t :: %__MODULE__{
          messaging_product: String.t() | nil,
          wa_id: String.t() | nil
        }
  defstruct [
    :messaging_product,
    :wa_id
  ]
end
