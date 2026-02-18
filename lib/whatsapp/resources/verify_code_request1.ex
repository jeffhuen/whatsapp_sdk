defmodule WhatsApp.Resources.VerifyCodeRequest1 do
  @moduledoc """
  Request payload for phone number verification code verification

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `String.t()` | The verification code received via SMS or voice call |

  ## `code` Constraints

  - Pattern: `^[0-9]{6}$`
  """

  @type t :: %__MODULE__{
          code: String.t()
        }
  @enforce_keys [:code]
  defstruct [
    :code
  ]
end
