defmodule WhatsApp.Resources.AudioSettings do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `status` | `String.t()` | Audio calling status |

  ## `status` Values
  | Value |
  | --- |
  | `enabled` |
  | `disabled` |
  """

  @type t :: %__MODULE__{
          status: String.t() | nil
        }
  defstruct [
    :status
  ]
end
