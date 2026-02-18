defmodule WhatsApp.Resources.GetBusinessComplianceInfo do
  @moduledoc false

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.BusinessComplianceInfo.t()) | nil
        }
  defstruct [
    :data
  ]
end
