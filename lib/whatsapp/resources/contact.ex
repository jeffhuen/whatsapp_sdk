defmodule WhatsApp.Resources.Contact do
  @moduledoc false

  @type t :: %__MODULE__{
          input: String.t(),
          wa_id: String.t() | nil
        }
  @enforce_keys [:input]
  defstruct [
    :input,
    :wa_id
  ]
end
