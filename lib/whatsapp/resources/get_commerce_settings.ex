defmodule WhatsApp.Resources.GetCommerceSettings do
  @moduledoc false

  @type t :: %__MODULE__{
          data: list(map()) | nil
        }
  defstruct [
    :data
  ]
end
