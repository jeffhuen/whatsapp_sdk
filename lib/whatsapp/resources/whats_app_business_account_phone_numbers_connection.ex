defmodule WhatsApp.Resources.WhatsAppBusinessAccountPhoneNumbersConnection do
  @moduledoc """
  Paginated collection of WhatsApp Business Account phone numbers

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of phone number records |
  | `paging` | `map()` | Cursor-based pagination information |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessAccountPhoneNumber.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
