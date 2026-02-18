defmodule WhatsApp.Resources.ConversationOrigin do
  @moduledoc false

  @type t :: %__MODULE__{
          type: String.t() | nil
        }
  defstruct [
    :type
  ]
end
