defmodule WhatsApp.Resources.DeleteQrCode do
  @moduledoc """
  Response confirming successful QR code deletion

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` | Indicates whether the QR code was successfully deleted |
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
