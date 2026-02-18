defmodule WhatsApp.Resources.AssignedUsers do
  @moduledoc """
  Response containing list of assigned users with pagination
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.AssignedUser.t()),
          paging: map() | nil,
          summary: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging,
    :summary
  ]
end
