defmodule WhatsApp.Resources.WhatsAppBusinessProfileUpdateResponse1 do
  @moduledoc """
  Response from updating WhatsApp Business Profile
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          success: boolean() | nil
        }
  defstruct [
    :id,
    :success
  ]
end
