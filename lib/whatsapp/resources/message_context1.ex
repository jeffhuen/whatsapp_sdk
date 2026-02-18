defmodule WhatsApp.Resources.MessageContext1 do
  @moduledoc false

  @type t :: %__MODULE__{
          message_id: String.t() | nil
        }
  defstruct [
    :message_id
  ]
end
