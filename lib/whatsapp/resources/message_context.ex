defmodule WhatsApp.Resources.MessageContext do
  @moduledoc """
  Context information for replying to a message
  """

  @type t :: %__MODULE__{
          message_id: String.t() | nil
        }
  defstruct [
    :message_id
  ]
end
