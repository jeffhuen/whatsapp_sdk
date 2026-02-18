defmodule WhatsApp.Resources.AudioSettings do
  @moduledoc """
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
