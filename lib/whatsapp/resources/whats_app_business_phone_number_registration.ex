defmodule WhatsApp.Resources.WhatsAppBusinessPhoneNumberRegistration do
  @moduledoc """
  Response from phone number registration request
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
