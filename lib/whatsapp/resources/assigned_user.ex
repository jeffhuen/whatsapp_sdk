defmodule WhatsApp.Resources.AssignedUser do
  @moduledoc """
  User assigned to WhatsApp Business Account with permissions

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `business` | `map()` | Business entity associated with the user |
  | `id` | `String.t()` | Unique identifier for the assigned user |
  | `name` | `String.t()` | Display name of the assigned user |
  | `user_type` | `String.t()` | Type of user assignment |

  ## `user_type` Values
  | Value |
  | --- |
  | `BUSINESS_USER` |
  | `SYSTEM_USER` |
  | `PERSONAL_USER` |
  """

  @type t :: %__MODULE__{
          business: map() | nil,
          id: String.t(),
          name: String.t(),
          user_type: String.t() | nil
        }
  @enforce_keys [:id, :name]
  defstruct [
    :business,
    :id,
    :name,
    :user_type
  ]
end
