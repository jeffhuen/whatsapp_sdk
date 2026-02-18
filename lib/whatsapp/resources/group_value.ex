defmodule WhatsApp.Resources.GroupValue do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `groups` | `list()` | Array of group objects. |
  | `messaging_product` | `String.t()` | Always 'whatsapp'. |
  | `metadata` | `map()` |  |
  """

  @type t :: %__MODULE__{
          groups: list(WhatsApp.Resources.Groups.t()),
          messaging_product: String.t(),
          metadata: map()
        }
  @enforce_keys [:messaging_product, :metadata, :groups]
  defstruct [
    :groups,
    :messaging_product,
    :metadata
  ]
end
