defmodule WhatsApp.Resources.AssignedAccounts do
  @moduledoc """
  Response containing assigned WhatsApp Business Accounts
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
