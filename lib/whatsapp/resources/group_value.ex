defmodule WhatsApp.Resources.GroupValue do
  @moduledoc false

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
