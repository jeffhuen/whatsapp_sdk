defmodule WhatsApp.Resources.BusinessSummary do
  @moduledoc """
  Summary information about a business entity

  ## `verification_status` Values
  | Value |
  | --- |
  | `VERIFIED` |
  | `UNVERIFIED` |
  | `PENDING` |
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          verification_status: String.t() | nil
        }
  defstruct [
    :id,
    :name,
    :verification_status
  ]
end
