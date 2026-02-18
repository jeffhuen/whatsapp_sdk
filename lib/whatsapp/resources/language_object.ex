defmodule WhatsApp.Resources.LanguageObject do
  @moduledoc """
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
