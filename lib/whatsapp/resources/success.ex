defmodule WhatsApp.Resources.Success do
  @moduledoc """
  Generic success response
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
