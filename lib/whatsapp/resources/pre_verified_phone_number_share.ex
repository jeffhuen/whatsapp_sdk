defmodule WhatsApp.Resources.PreVerifiedPhoneNumberShare do
  @moduledoc """
  Response containing details of the successful phone number sharing operation
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
