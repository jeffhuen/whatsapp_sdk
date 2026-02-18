defmodule WhatsApp.Resources.MessageContext1 do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `message_id` | `String.t()` | ID of message being replied to |
  """

  @type t :: %__MODULE__{
          message_id: String.t() | nil
        }
  defstruct [
    :message_id
  ]
end
