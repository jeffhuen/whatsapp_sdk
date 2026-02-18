defmodule WhatsApp.Resources.RequestCodeRequest1 do
  @moduledoc """
  Request body for requesting verification code

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code_method` | `String.t()` | Method for receiving the verification code |
  | `language` | `String.t()` | Language/locale code for the verification message. Must be a valid locale identifier.
  The verification message will be sent in this language if supported.
  Supports various formats including xx_XX, xx-XX, and extended locale codes.
   |

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
