defmodule WhatsApp.Resources.AssignedAccounts do
  @moduledoc """
  Response containing assigned WhatsApp Business Accounts

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | List of assigned WhatsApp Business Accounts |
  | `paging` | `map()` |  |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.AssignedWhatsAppBusinessAccount.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
