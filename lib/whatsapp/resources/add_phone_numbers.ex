defmodule WhatsApp.Resources.AddPhoneNumbers do
  @moduledoc """
  Response containing the ID of the successfully added phone number
  """

  @type t :: %__MODULE__{
          id: String.t()
        }
  @enforce_keys [:id]
  defstruct [
    :id
  ]
end
