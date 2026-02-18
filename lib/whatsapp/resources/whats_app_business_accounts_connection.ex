defmodule WhatsApp.Resources.WhatsAppBusinessAccountsConnection do
  @moduledoc """
  Paginated collection of owned WhatsApp Business Accounts
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
