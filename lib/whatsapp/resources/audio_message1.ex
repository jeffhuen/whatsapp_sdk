defmodule WhatsApp.Resources.AudioMessage1 do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `audio` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          audio: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :audio]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :audio
  ]
end
