defmodule WhatsApp.Resources.CallIconsSettings do
  @moduledoc false

  @type t :: %__MODULE__{
          restrict_to_user_countries: list(String.t()) | nil
        }
  defstruct [
    :restrict_to_user_countries
  ]
end
