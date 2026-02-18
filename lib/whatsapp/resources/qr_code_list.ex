defmodule WhatsApp.Resources.QrCodeList do
  @moduledoc """
  List of message QR codes with pagination information

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of QR code objects |
  | `paging` | `map()` | Pagination information for navigating through large result sets.
  Contains cursors for accessing previous and next pages of results.
   |
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
