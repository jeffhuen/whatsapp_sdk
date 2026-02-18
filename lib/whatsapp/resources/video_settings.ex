defmodule WhatsApp.Resources.VideoSettings do
  @moduledoc """
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
