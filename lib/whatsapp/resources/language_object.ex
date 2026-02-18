defmodule WhatsApp.Resources.LanguageObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `String.t()` | The code of the language or locale to use (e.g., `"en"`, `"en_US"`). |
  | `policy` | `String.t()` | The language policy the message should follow. |

  ## `policy` Values
  | Value |
  | --- |
  | `deterministic` |
  """

  @type t :: %__MODULE__{
          code: String.t(),
          policy: String.t()
        }
  @enforce_keys [:policy, :code]
  defstruct [
    :code,
    :policy
  ]
end
