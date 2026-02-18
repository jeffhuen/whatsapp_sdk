defmodule WhatsApp.Resources.SuccessResponse1 do
  @moduledoc """
  Standard success response for write operations
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
