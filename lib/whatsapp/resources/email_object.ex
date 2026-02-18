defmodule WhatsApp.Resources.EmailObject do
  @moduledoc """
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
