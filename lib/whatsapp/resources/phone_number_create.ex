defmodule WhatsApp.Resources.PhoneNumberCreate do
  @moduledoc """
  Response after successfully creating a phone number registration
  """

  @type t :: %__MODULE__{
          id: String.t()
        }
  @enforce_keys [:id]
  defstruct [
    :id
  ]
end
