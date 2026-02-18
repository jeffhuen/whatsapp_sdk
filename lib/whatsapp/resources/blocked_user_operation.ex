defmodule WhatsApp.Resources.BlockedUserOperation do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `input` | `String.t()` |  |
  | `wa_id` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          input: String.t() | nil,
          wa_id: String.t() | nil
        }
  defstruct [
    :input,
    :wa_id
  ]
end
