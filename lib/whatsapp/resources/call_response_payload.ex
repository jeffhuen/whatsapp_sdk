defmodule WhatsApp.Resources.CallResponsePayload do
  @moduledoc false

  @type t :: %__MODULE__{
          calls: list(map()) | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :calls,
    :messaging_product
  ]
end
