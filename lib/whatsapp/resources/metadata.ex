defmodule WhatsApp.Resources.Metadata do
  @moduledoc false

  @type t :: %__MODULE__{
          display_phone_number: String.t(),
          phone_number_id: String.t()
        }
  @enforce_keys [:display_phone_number, :phone_number_id]
  defstruct [
    :display_phone_number,
    :phone_number_id
  ]
end
