defmodule WhatsApp.Resources.AssignedUsersSummary do
  @moduledoc """
  Summary information about assigned users
  """

  @type t :: %__MODULE__{
          total_count: integer() | nil
        }
  defstruct [
    :total_count
  ]
end
