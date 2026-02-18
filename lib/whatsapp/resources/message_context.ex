defmodule WhatsApp.Resources.MessageContext do
  @moduledoc """
  Context information for replying to a message

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `message_id` | `String.t()` | The ID of the message to which this message is a reply. |
  """

  @type t :: %__MODULE__{
          message_id: String.t() | nil
        }
  defstruct [
    :message_id
  ]
end
