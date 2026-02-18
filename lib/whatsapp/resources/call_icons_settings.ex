defmodule WhatsApp.Resources.CallIconsSettings do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `restrict_to_user_countries` | `list()` | List of countries where call icons are restricted |
  """

  @type t :: %__MODULE__{
          restrict_to_user_countries: list(String.t()) | nil
        }
  defstruct [
    :restrict_to_user_countries
  ]
end
