defmodule WhatsApp.Resources.DeleteGroupInviteLink do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `messaging_product` | `String.t()` |  |
  | `success` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          messaging_product: String.t() | nil,
          success: String.t() | nil
        }
  defstruct [
    :messaging_product,
    :success
  ]
end
