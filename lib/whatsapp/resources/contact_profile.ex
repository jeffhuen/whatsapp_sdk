defmodule WhatsApp.Resources.ContactProfile do
  @moduledoc false

  @type t :: %__MODULE__{
          profile: map(),
          wa_id: String.t() | nil
        }
  @enforce_keys [:profile]
  defstruct [
    :profile,
    :wa_id
  ]
end
