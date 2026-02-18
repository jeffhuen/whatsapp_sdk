defmodule WhatsApp.Resources.LocationMessage1 do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `location` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          location: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :location]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :location
  ]
end
