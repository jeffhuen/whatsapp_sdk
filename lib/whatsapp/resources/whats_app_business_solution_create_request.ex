defmodule WhatsApp.Resources.WhatsAppBusinessSolutionCreateRequest do
  @moduledoc """
  Request payload for creating a Multi-Partner Solution

  ## `owner_permissions` Constraints

  - Maximum items: 1

  ## `partner_app_id` Constraints

  - Pattern: `^[0-9]+$`

  ## `partner_permissions` Constraints

  - Maximum items: 1

  ## `solution_name` Constraints

  - Minimum length: 2
  - Maximum length: 75
  """

  @type t :: %__MODULE__{
          owner_permissions: list(term()),
          partner_app_id: String.t(),
          partner_permissions: list(term()),
          solution_name: String.t()
        }
  @enforce_keys [:owner_permissions, :partner_app_id, :partner_permissions, :solution_name]
  defstruct [
    :owner_permissions,
    :partner_app_id,
    :partner_permissions,
    :solution_name
  ]
end
