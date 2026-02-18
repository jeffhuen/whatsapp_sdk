defmodule WhatsApp.Resources.RequestCodeRequest do
  @moduledoc """
  Request body for requesting a verification code

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code_method` | `String.t()` | Method for receiving the verification code |
  | `language` | `String.t()` | Language locale for the verification message |

  ## `code_method` Values
  | Value |
  | --- |
  | `SMS` |
  | `VOICE` |

  ## `language` Constraints

  - Minimum length: 5
  - Maximum length: 5
  - Pattern: `^[a-z]{2}_[A-Z]{2}$`
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
