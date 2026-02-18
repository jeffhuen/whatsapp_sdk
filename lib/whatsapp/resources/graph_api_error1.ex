defmodule WhatsApp.Resources.GraphAPIError1 do
  @moduledoc """
  Standard Graph API error response structure
  """

  @type t :: %__MODULE__{
          error: map()
        }
  @enforce_keys [:error]
  defstruct [
    :error
  ]
end
