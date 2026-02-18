defmodule WhatsApp.Resources.ConnectedClientBusinesses do
  @moduledoc """
  Response containing list of connected client businesses
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.ConnectedClientBusiness.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
