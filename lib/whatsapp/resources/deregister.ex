defmodule WhatsApp.Resources.Deregister do
  @moduledoc """
  Response indicating successful phone number deregistration

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` | Indicates whether the deregistration was successful |
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
