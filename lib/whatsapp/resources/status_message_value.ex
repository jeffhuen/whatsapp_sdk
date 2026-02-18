defmodule WhatsApp.Resources.StatusMessageValue do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `messaging_product` | `String.t()` | Always 'whatsapp'. |
  | `metadata` | `map()` |  |
  | `statuses` | `list()` | Array of status objects. |
  """

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
