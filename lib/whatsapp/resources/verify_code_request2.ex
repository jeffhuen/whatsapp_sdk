defmodule WhatsApp.Resources.VerifyCodeRequest2 do
  @moduledoc """
  Request payload for verifying OTP code

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
