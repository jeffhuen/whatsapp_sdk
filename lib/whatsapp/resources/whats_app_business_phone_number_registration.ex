defmodule WhatsApp.Resources.WhatsAppBusinessPhoneNumberRegistration do
  @moduledoc """
  Response from phone number registration request

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` | Indicates whether the registration was successful |
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
