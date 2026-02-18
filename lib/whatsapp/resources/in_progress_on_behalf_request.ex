defmodule WhatsApp.Resources.InProgressOnBehalfRequest do
  @moduledoc """
  Response containing in-progress on-behalf requests with pagination

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of in-progress on-behalf requests |
  | `paging` | `map()` | Pagination information for navigating through results |
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
