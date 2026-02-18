defmodule WhatsApp.Resources.DeleteGroupInviteLinkRequest do
  @moduledoc """
  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |
  """

  @type t :: %__MODULE__{
          messaging_product: String.t()
        }
  @enforce_keys [:messaging_product]
  defstruct [
    :messaging_product
  ]
end
