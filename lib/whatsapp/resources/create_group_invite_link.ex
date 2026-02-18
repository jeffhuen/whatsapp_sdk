defmodule WhatsApp.Resources.CreateGroupInviteLink do
  @moduledoc false

  @type t :: %__MODULE__{
          invite_link: String.t() | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :invite_link,
    :messaging_product
  ]
end
