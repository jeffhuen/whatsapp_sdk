defmodule WhatsApp.Resources.GetJoinRequests do
  @moduledoc false

  @type t :: %__MODULE__{
          data: list(map()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
