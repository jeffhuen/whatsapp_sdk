defmodule WhatsApp.Resources.VerifyCodeResponse1 do
  @moduledoc """
  Response indicating successful code verification
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
