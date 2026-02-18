defmodule WhatsApp.Resources.InteractiveObject do
  @moduledoc """
  An object containing the content for an interactive message.

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `action` | `map()` | Action you want the user to perform after reading the message. Its structure varies by interactive message type. |
  | `body` | `map()` | An object with the body of the message. Optional for 'product' type, required for other interactive message types. |
  | `footer` | `map()` | An object with the footer of the message. Optional. |
  | `header` | `map()` | Header content displayed on top of a message. Required for 'product_list' type. Cannot be set for 'product' type. |
  | `type` | `String.t()` | The type of interactive message to send. |

  ## `type` Values
  | Value |
  | --- |
  | `button` |
  | `call_permission_request` |
  | `catalog_message` |
  | `list` |
  | `product` |
  | `product_list` |
  | `flow` |
  """

  @type t :: %__MODULE__{
          action: map(),
          body: map() | nil,
          footer: map() | nil,
          header: map() | nil,
          type: String.t()
        }
  @enforce_keys [:type, :action]
  defstruct [
    :action,
    :body,
    :footer,
    :header,
    :type
  ]
end
