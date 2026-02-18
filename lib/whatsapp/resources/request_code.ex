defmodule WhatsApp.Resources.RequestCode do
  @moduledoc """
  Response after successfully requesting a verification code

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` | Indicates whether the verification code request was successful |
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
