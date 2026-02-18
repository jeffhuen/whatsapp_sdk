defmodule WhatsApp.Resources.InteractiveObject do
  @moduledoc """
  An object containing the content for an interactive message.

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
