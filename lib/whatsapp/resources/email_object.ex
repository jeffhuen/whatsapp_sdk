defmodule WhatsApp.Resources.EmailObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `email` | `String.t()` | Email address |
  | `type` | `String.t()` | Email type |

  ## `type` Values
  | Value |
  | --- |
  | `HOME` |
  | `WORK` |
  """

  @type t :: %__MODULE__{
          email: String.t(),
          type: String.t() | nil
        }
  @enforce_keys [:email]
  defstruct [
    :email,
    :type
  ]
end
