defmodule WhatsApp.Resources.Conversation do
  @moduledoc false

  @type t :: %__MODULE__{
          expiration_timestamp: String.t() | nil,
          id: String.t() | nil,
          origin: map() | nil
        }
  defstruct [
    :expiration_timestamp,
    :id,
    :origin
  ]
end
