defmodule WhatsApp.Resources.SettingsRequest do
  @moduledoc """
  Request to update phone number settings

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `calling` | `map()` |  |
  """

  @type t :: %__MODULE__{
          calling: map() | nil
        }
  defstruct [
    :calling
  ]
end
