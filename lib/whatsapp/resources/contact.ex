defmodule WhatsApp.Resources.Contact do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `input` | `String.t()` | Input phone number |
  | `wa_id` | `String.t()` | WhatsApp ID |
  """

  @type t :: %__MODULE__{
          input: String.t(),
          wa_id: String.t() | nil
        }
  @enforce_keys [:input]
  defstruct [
    :input,
    :wa_id
  ]
end
