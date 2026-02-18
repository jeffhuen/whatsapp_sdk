defmodule WhatsApp.Resources.VideoSettings do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `status` | `String.t()` | Enable or disable video calling |

  ## `status` Values
  | Value |
  | --- |
  | `enabled` |
  | `disabled` |
  """

  @type t :: %__MODULE__{
          status: String.t()
        }
  @enforce_keys [:status]
  defstruct [
    :status
  ]
end
