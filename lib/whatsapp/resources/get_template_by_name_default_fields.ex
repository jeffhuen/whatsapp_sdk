defmodule WhatsApp.Resources.GetTemplateByNameDefaultFields do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` |  |
  | `paging` | `map()` |  |
  """

  @type t :: %__MODULE__{
          data: list(map()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
