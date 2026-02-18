defmodule WhatsApp.Resources.CallRequestPayload do
  @moduledoc """
  ## `action` Values
  | Value |
  | --- |
  | `connect` |
  | `pre_accept` |
  | `accept` |
  | `reject` |
  | `terminate` |

  ## `biz_opaque_callback_data` Constraints

  - Maximum length: 512
  """

  @type t :: %__MODULE__{
          action: String.t(),
          biz_opaque_callback_data: String.t() | nil,
          messaging_product: String.t(),
          session: map() | nil,
          to: String.t()
        }
  @enforce_keys [:messaging_product, :to, :action]
  defstruct [
    :action,
    :biz_opaque_callback_data,
    :messaging_product,
    :session,
    :to
  ]
end
