defmodule WhatsApp.Resources.TwoStepVerificationRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `pin` | `String.t()` | 6-digit PIN for two-step verification |

  ## `pin` Constraints

  - Pattern: `^[0-9]{6}$`
  """

  @type t :: %__MODULE__{
          pin: String.t()
        }
  @enforce_keys [:pin]
  defstruct [
    :pin
  ]
end
