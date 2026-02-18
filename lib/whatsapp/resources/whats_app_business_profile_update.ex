defmodule WhatsApp.Resources.WhatsAppBusinessProfileUpdate do
  @moduledoc """
  Response after updating business profile
  """

  @type t :: %__MODULE__{
          success: boolean() | nil
        }
  defstruct [
    :success
  ]
end
