defmodule WhatsApp.Resources.VerifyCodeRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `String.t()` | 6-digit verification code received via SMS or voice |

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
