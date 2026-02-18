defmodule WhatsApp.Resources.RequestCodeResponse1 do
  @moduledoc """
  Response after successfully requesting verification code
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
