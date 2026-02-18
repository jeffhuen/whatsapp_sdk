defmodule WhatsApp.Resources.ActivityList do
  @moduledoc """
  Paginated list of WhatsApp Business Account activities
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessAccountActivity.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
