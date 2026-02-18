defmodule WhatsApp.Resources.TwoStepVerificationRequest do
  @moduledoc """
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
