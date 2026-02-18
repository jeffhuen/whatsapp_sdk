defmodule WhatsApp.Resources.BaseMessageProperties do
  @moduledoc """
  Common properties shared by all message types

  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type
  ]
end
