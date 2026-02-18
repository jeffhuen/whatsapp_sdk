defmodule WhatsApp.Resources.QrCodeList do
  @moduledoc """
  List of message QR codes with pagination information
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.QrCode.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
