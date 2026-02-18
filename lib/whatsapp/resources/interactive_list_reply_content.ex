defmodule WhatsApp.Resources.InteractiveListReplyContent do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `list_reply` | `map()` |  |
  """

  @type t :: %__MODULE__{
          list_reply: map()
        }
  @enforce_keys [:list_reply]
  defstruct [
    :list_reply
  ]
end
