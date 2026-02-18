defmodule WhatsApp.Resources.Change do
  @moduledoc """
  ## `field` Values
  | Value |
  | --- |
  | `messages` |
  | `group_lifecycle_update` |
  | `group_settings_update` |
  | `group_participant_update` |
  """

  @type t :: %__MODULE__{
          field: String.t(),
          value: term()
        }
  @enforce_keys [:value, :field]
  defstruct [
    :field,
    :value
  ]
end
