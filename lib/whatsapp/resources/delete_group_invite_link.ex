defmodule WhatsApp.Resources.DeleteGroupInviteLink do
  @moduledoc false

  @type t :: %__MODULE__{
          messaging_product: String.t() | nil,
          success: String.t() | nil
        }
  defstruct [
    :messaging_product,
    :success
  ]
end
