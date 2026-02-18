defmodule WhatsApp.Resources.GetActiveGroups do
  @moduledoc false

  @type t :: %__MODULE__{
          data: map() | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
