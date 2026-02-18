defmodule WhatsApp.Resources.StatusMessageValue do
  @moduledoc false

  @type t :: %__MODULE__{
          messaging_product: String.t(),
          metadata: map(),
          statuses: list(WhatsApp.Resources.Statuses.t())
        }
  @enforce_keys [:messaging_product, :metadata, :statuses]
  defstruct [
    :messaging_product,
    :metadata,
    :statuses
  ]
end
