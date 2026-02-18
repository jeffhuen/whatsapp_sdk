defmodule WhatsApp.Resources.ImageParameter do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `term()` |  |
  | `image` | `map()` | A media object. Either `id` or `link` is required. |

  ## `type` Values
  | Value |
  | --- |
  | `image` |
  """

  @type t :: %__MODULE__{
          type: term(),
          image: map()
        }
  @enforce_keys [:type, :image]
  defstruct [
    :type,
    :image
  ]
end
