defmodule WhatsApp.Resources.UpdateBusinessComplianceInfo do
  @moduledoc false

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
