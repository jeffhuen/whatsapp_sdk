defmodule WhatsApp.Resources.GroupParticipant do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `input` | `String.t()` | Input phone number or WhatsApp ID |
  | `wa_id` | `String.t()` | WhatsApp ID of the participant |
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
