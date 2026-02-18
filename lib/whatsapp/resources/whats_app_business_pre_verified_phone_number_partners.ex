defmodule WhatsApp.Resources.WhatsAppBusinessPreVerifiedPhoneNumberPartners do
  @moduledoc """
  Response containing partner businesses for a pre-verified phone number

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | List of partner businesses with access to the pre-verified phone number |
  | `paging` | `map()` | Cursor-based pagination information |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.BusinessPartner.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
