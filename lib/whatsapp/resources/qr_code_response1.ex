defmodule WhatsApp.Resources.QrCodeResponse1 do
  @moduledoc """
  Individual QR code response containing a single QR code in data array format

  ## `data` Constraints

  - Minimum items: 1
  - Maximum items: 1
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.QrCode.t())
        }
  @enforce_keys [:data]
  defstruct [
    :data
  ]
end
