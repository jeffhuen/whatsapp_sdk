defmodule WhatsApp.Resources.PreVerifiedPhoneNumberShare do
  @moduledoc """
  Response containing details of the successful phone number sharing operation

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` | Indicates whether the sharing operation was successful |
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
