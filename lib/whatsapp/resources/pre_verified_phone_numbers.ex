defmodule WhatsApp.Resources.PreVerifiedPhoneNumbers do
  @moduledoc """
  Response containing list of pre-verified phone numbers

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | List of pre-verified phone numbers |
  | `paging` | `map()` | Cursor-based pagination information |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.PreVerifiedPhoneNumber.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
