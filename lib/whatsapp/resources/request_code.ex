defmodule WhatsApp.Resources.RequestCode do
  @moduledoc """
  Response after successfully requesting a verification code
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
