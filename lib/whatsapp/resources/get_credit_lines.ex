defmodule WhatsApp.Resources.GetCreditLines do
  @moduledoc false

  @type t :: %__MODULE__{
          data: list(map()) | nil
        }
  defstruct [
    :data
  ]
end
