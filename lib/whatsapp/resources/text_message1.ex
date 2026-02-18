defmodule WhatsApp.Resources.TextMessage1 do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `body` | `String.t()` | Text content of the message |
  | `preview_url` | `boolean()` | Whether to show URL preview |

  ## `body` Constraints

  - Maximum length: 4096
  """

  @type t :: %__MODULE__{
          body: String.t(),
          preview_url: boolean() | nil
        }
  @enforce_keys [:body]
  defstruct [
    :body,
    preview_url: false
  ]
end
