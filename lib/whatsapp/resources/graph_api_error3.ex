defmodule WhatsApp.Resources.GraphAPIError3 do
  @moduledoc """
  Standard Graph API error response
  """

  @type t :: %__MODULE__{
          error: map()
        }
  @enforce_keys [:error]
  defstruct [
    :error
  ]
end
