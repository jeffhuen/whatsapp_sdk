defmodule WhatsApp.Resources.Deregister do
  @moduledoc """
  Response indicating successful phone number deregistration
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
