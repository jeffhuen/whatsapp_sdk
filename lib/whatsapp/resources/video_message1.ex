defmodule WhatsApp.Resources.VideoMessage1 do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `video` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          video: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :video]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :video
  ]
end
