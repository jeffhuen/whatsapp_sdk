defmodule WhatsApp.Resources.BusinessSummary do
  @moduledoc """
  Summary information about a business entity

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the business |
  | `name` | `String.t()` | Name of the business |
  | `verification_status` | `String.t()` | Business verification status |

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
