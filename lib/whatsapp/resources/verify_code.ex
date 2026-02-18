defmodule WhatsApp.Resources.VerifyCode do
  @moduledoc """
  Response from phone number verification code verification
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :id,
    :success
  ]
end
