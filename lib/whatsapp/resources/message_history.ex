defmodule WhatsApp.Resources.MessageHistory do
  @moduledoc """
  Paginated response containing message history entries
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppMessageHistory.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
