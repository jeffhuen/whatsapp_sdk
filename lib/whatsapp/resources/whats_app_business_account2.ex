defmodule WhatsApp.Resources.WhatsAppBusinessAccount2 do
  @moduledoc """
  WhatsApp Business Account information

  ## `status` Values
  | Value |
  | --- |
  | `ACTIVE` |
  | `INACTIVE` |
  | `PENDING` |
  """

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          status: String.t() | nil
        }
  @enforce_keys [:id, :name]
  defstruct [
    :id,
    :name,
    :status
  ]
end
