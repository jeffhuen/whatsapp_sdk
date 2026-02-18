defmodule WhatsApp.Resources.ClientWhatsAppBusinessAccounts do
  @moduledoc """
  Response containing list of client WhatsApp Business Accounts
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
