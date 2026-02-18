defmodule WhatsApp.Resources.GetBusinessPortfolioSpecificFields do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` |  |
  | `name` | `String.t()` |  |
  | `timezone_id` | `float()` |  |
  """

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
