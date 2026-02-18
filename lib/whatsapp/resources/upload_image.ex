defmodule WhatsApp.Resources.UploadImage do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          id: String.t() | nil
        }
  defstruct [
    :id
  ]
end
