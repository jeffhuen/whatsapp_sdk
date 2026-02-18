defmodule WhatsApp.Resources.AddPhoneNumbers do
  @moduledoc """
  Response containing the ID of the successfully added phone number

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the preverified phone number entity that was created |
  """

  @type t :: %__MODULE__{
          id: String.t()
        }
  @enforce_keys [:id]
  defstruct [
    :id
  ]
end
