defmodule WhatsApp.Resources.WhatsAppBusinessProfileUpdate do
  @moduledoc """
  Response after updating business profile

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` | Indicates whether the update was successful |
  """

  @type t :: %__MODULE__{
          success: boolean() | nil
        }
  defstruct [
    :success
  ]
end
