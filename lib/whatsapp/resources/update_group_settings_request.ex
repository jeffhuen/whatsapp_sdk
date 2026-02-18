defmodule WhatsApp.Resources.UpdateGroupSettingsRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `description` | `String.t()` | The new description for the group |
  | `messaging_product` | `String.t()` |  |
  | `profile_picture_file` | `String.t()` | Path to an image file for group profile picture |
  | `subject` | `String.t()` | The new subject for the group |

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |

  ## `description` Constraints

  - Maximum length: 2048

  ## `subject` Constraints

  - Maximum length: 128
  """

  @type t :: %__MODULE__{
          description: String.t() | nil,
          messaging_product: String.t(),
          profile_picture_file: String.t() | nil,
          subject: String.t() | nil
        }
  @enforce_keys [:messaging_product]
  defstruct [
    :description,
    :messaging_product,
    :profile_picture_file,
    :subject
  ]
end
