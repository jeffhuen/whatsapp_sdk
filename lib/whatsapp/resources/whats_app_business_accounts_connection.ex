defmodule WhatsApp.Resources.WhatsAppBusinessAccountsConnection do
  @moduledoc """
  Paginated collection of owned WhatsApp Business Accounts

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of owned WhatsApp Business Account records |
  | `paging` | `map()` | Cursor-based pagination information |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessAccount.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
