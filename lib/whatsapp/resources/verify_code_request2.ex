defmodule WhatsApp.Resources.VerifyCodeRequest2 do
  @moduledoc """
  Request payload for verifying OTP code

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `String.t()` | The numeric verification code received via SMS or voice call.
  This code is provided after calling the request_code endpoint.
   |

  ## `code` Constraints

  - Minimum length: 4
  - Maximum length: 8
  - Pattern: `^[0-9]+$`
  """

  @type t :: %__MODULE__{
          code: String.t()
        }
  @enforce_keys [:code]
  defstruct [
    :code
  ]
end
