defmodule WhatsApp.Resources.InteractiveButtonReplyContent do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `button_reply` | `map()` |  |
  """

  @type t :: %__MODULE__{
          button_reply: map()
        }
  @enforce_keys [:button_reply]
  defstruct [
    :button_reply
  ]
end
