defmodule WhatsApp.Resources.ConversationOrigin do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          type: String.t() | nil
        }
  defstruct [
    :type
  ]
end
