defmodule WhatsApp.Resources.GraphAPIError8 do
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
