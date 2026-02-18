defmodule WhatsApp.Resources.HeaderObject do
  @moduledoc """
  Header content displayed on top of a message. Required for 'product_list' type. Cannot be set for 'product' type.

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
