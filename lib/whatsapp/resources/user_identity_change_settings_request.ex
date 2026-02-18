defmodule WhatsApp.Resources.UserIdentityChangeSettingsRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          user_identity_change: map()
        }
  @enforce_keys [:user_identity_change]
  defstruct [
    :user_identity_change
  ]
end
