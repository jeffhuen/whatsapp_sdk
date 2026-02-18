defmodule WhatsApp.Resources.DocumentParameter do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `term()` |  |
  | `document` | `map()` | A media object. Either `id` or `link` is required. |

  ## `type` Values
  | Value |
  | --- |
  | `document` |
  """

  @type t :: %__MODULE__{
          type: term(),
          document: map()
        }
  @enforce_keys [:type, :document]
  defstruct [
    :type,
    :document
  ]
end
