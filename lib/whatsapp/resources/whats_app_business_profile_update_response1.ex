defmodule WhatsApp.Resources.WhatsAppBusinessProfileUpdateResponse1 do
  @moduledoc """
  Response from updating WhatsApp Business Profile

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | WhatsApp Business Profile ID that was updated |
  | `success` | `boolean()` | Indicates if the update was successful |
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          success: boolean() | nil
        }
  defstruct [
    :id,
    :success
  ]
end
