defmodule WhatsApp.Resources.PhoneNumberCreate do
  @moduledoc """
  Response after successfully creating a phone number registration

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the created phone number status record |
  """

  @type t :: %__MODULE__{
          id: String.t()
        }
  @enforce_keys [:id]
  defstruct [
    :id
  ]
end
