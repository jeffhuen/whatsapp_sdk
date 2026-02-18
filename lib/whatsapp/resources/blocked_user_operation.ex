defmodule WhatsApp.Resources.BlockedUserOperation do
  @moduledoc false

  @type t :: %__MODULE__{
          input: String.t() | nil,
          wa_id: String.t() | nil
        }
  defstruct [
    :input,
    :wa_id
  ]
end
