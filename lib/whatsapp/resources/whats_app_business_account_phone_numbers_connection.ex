defmodule WhatsApp.Resources.WhatsAppBusinessAccountPhoneNumbersConnection do
  @moduledoc """
  Paginated collection of WhatsApp Business Account phone numbers
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
