defmodule WhatsApp.Resources.AssignedUsersSummary do
  @moduledoc """
  Summary information about assigned users

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `total_count` | `integer()` | Total number of assigned users |
  """

  @type t :: %__MODULE__{
          total_count: integer() | nil
        }
  defstruct [
    :total_count
  ]
end
