defmodule WhatsApp.Resources.InteractiveButtonReplyContent do
  @moduledoc false

  @type t :: %__MODULE__{
          button_reply: map()
        }
  @enforce_keys [:button_reply]
  defstruct [
    :button_reply
  ]
end
