defmodule WhatsApp.Resources.WhatsAppBusinessApiData1 do
  @moduledoc """
  Application subscription data for WhatsApp Business Account
  """

  @type t :: %__MODULE__{
          id: String.t(),
          link: String.t() | nil,
          name: String.t()
        }
  @enforce_keys [:id, :name]
  defstruct [
    :id,
    :link,
    :name
  ]
end
