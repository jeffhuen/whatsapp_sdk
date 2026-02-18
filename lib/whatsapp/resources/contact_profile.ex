defmodule WhatsApp.Resources.ContactProfile do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `profile` | `map()` |  |
  | `wa_id` | `String.t()` | WhatsApp user ID. Note that a WhatsApp user's ID and phone number may not always match. |
  """

  @type t :: %__MODULE__{
          profile: map(),
          wa_id: String.t() | nil
        }
  @enforce_keys [:profile]
  defstruct [
    :profile,
    :wa_id
  ]
end
