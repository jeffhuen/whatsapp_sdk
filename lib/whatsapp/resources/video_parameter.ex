defmodule WhatsApp.Resources.VideoParameter do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `term()` |  |
  | `video` | `map()` | A media object. Either `id` or `link` is required. |

  ## `type` Values
  | Value |
  | --- |
  | `video` |
  """

  @type t :: %__MODULE__{
          type: term(),
          video: map()
        }
  @enforce_keys [:type, :video]
  defstruct [
    :type,
    :video
  ]
end
