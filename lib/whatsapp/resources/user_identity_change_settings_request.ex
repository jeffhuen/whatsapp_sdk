defmodule WhatsApp.Resources.UserIdentityChangeSettingsRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `user_identity_change` | `map()` |  |
  """

  @type t :: %__MODULE__{
          user_identity_change: map()
        }
  @enforce_keys [:user_identity_change]
  defstruct [
    :user_identity_change
  ]
end
