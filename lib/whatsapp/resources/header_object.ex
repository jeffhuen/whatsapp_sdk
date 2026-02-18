defmodule WhatsApp.Resources.HeaderObject do
  @moduledoc """
  Header content displayed on top of a message. Required for 'product_list' type. Cannot be set for 'product' type.

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `document` | `map()` | A media object. Either `id` or `link` is required. |
  | `image` | `map()` | A media object. Either `id` or `link` is required. |
  | `sub_text` | `String.t()` | Optional sub-text for the header. Emojis supported, no markdown. |
  | `text` | `String.t()` | Text for the header. Required if 'type' is 'text'. Emojis supported, no markdown. |
  | `type` | `String.t()` | The header type. |
  | `video` | `map()` | A media object. Either `id` or `link` is required. |

  ## `type` Values
  | Value |
  | --- |
  | `text` |
  | `video` |
  | `image` |
  | `document` |

  ## `sub_text` Constraints

  - Maximum length: 60

  ## `text` Constraints

  - Maximum length: 60
  """

  @type t :: %__MODULE__{
          document: map() | nil,
          image: map() | nil,
          sub_text: String.t() | nil,
          text: String.t() | nil,
          type: String.t(),
          video: map() | nil
        }
  @enforce_keys [:type]
  defstruct [
    :document,
    :image,
    :sub_text,
    :text,
    :type,
    :video
  ]
end
