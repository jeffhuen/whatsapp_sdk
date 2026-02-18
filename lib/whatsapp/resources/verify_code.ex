defmodule WhatsApp.Resources.VerifyCode do
  @moduledoc """
  Response from phone number verification code verification

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | The phone number ID that was verified |
  | `success` | `boolean()` | Indicates whether the verification code was successfully verified |
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
