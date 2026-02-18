defmodule WhatsApp.Resources.DeleteTemplateByName do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` |  |
  """

  @type t :: %__MODULE__{
          success: boolean() | nil
        }
  defstruct [
    :success
  ]
end
