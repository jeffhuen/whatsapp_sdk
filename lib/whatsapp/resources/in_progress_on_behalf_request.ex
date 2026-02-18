defmodule WhatsApp.Resources.InProgressOnBehalfRequest do
  @moduledoc """
  Response containing in-progress on-behalf requests with pagination
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.BusinessOwnedObjectOnBehalfOfRequest.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
