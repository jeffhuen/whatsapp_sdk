defmodule WhatsApp.Resources.Metadata do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `display_phone_number` | `String.t()` | Business display phone number. |
  | `phone_number_id` | `String.t()` | Business phone number ID. |
  """

  @type t :: %__MODULE__{
          display_phone_number: String.t(),
          phone_number_id: String.t()
        }
  @enforce_keys [:display_phone_number, :phone_number_id]
  defstruct [
    :display_phone_number,
    :phone_number_id
  ]
end
