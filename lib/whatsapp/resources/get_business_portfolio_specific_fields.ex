defmodule WhatsApp.Resources.GetBusinessPortfolioSpecificFields do
  @moduledoc false

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          timezone_id: float() | nil
        }
  defstruct [
    :id,
    :name,
    :timezone_id
  ]
end
