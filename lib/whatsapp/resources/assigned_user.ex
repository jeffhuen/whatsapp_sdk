defmodule WhatsApp.Resources.AssignedUser do
  @moduledoc """
  User assigned to WhatsApp Business Account with permissions

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
