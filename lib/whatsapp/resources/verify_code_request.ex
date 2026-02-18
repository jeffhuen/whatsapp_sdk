defmodule WhatsApp.Resources.VerifyCodeRequest do
  @moduledoc """
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
