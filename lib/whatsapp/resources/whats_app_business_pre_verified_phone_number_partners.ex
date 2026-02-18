defmodule WhatsApp.Resources.WhatsAppBusinessPreVerifiedPhoneNumberPartners do
  @moduledoc """
  Response containing partner businesses for a pre-verified phone number
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
