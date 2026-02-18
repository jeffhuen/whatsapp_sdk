defmodule WhatsApp.Resources.VerifyCodeResponse1 do
  @moduledoc """
  Response indicating successful code verification

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` | Indicates whether the code verification was successful |
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
