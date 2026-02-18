defmodule WhatsApp.Resources.ClientWhatsAppBusinessAccounts do
  @moduledoc """
  Response containing list of client WhatsApp Business Accounts

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of client WhatsApp Business Accounts |
  | `paging` | `map()` | Cursor-based pagination information |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessAccount.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
