defmodule WhatsApp.Resources.RequestCodeRequest1 do
  @moduledoc """
  Request body for requesting verification code

  ## `code_method` Values
  | Value |
  | --- |
  | `SMS` |
  | `VOICE` |
  """

  @type t :: %__MODULE__{
          code_method: String.t(),
          language: String.t()
        }
  @enforce_keys [:code_method, :language]
  defstruct [
    :code_method,
    :language
  ]
end
