defmodule WhatsApp.Resources.CreateGroupInviteLink do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `invite_link` | `String.t()` | Group invite link |
  | `messaging_product` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          invite_link: String.t() | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :invite_link,
    :messaging_product
  ]
end
