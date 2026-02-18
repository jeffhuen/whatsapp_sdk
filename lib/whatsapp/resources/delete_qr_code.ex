defmodule WhatsApp.Resources.DeleteQrCode do
  @moduledoc """
  Response confirming successful QR code deletion
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
