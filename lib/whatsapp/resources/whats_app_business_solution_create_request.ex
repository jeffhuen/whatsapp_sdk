defmodule WhatsApp.Resources.WhatsAppBusinessSolutionCreateRequest do
  @moduledoc """
  Request payload for creating a Multi-Partner Solution

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `owner_permissions` | `list()` | Configurable permissions granted to the solution owner app. Currently supports
  only MESSAGING permission. Use empty array if owner should not have configurable permissions.
   |
  | `partner_app_id` | `String.t()` | Facebook Application ID of the partner app that will participate in this solution.
  Must be a valid application ID accessible to the requesting entity.
   |
  | `partner_permissions` | `list()` | Configurable permissions granted to the partner app. Currently supports
  only MESSAGING permission. Use empty array if partner should not have configurable permissions.
   |
  | `solution_name` | `String.t()` | Human-readable name for the Multi-Partner Solution. Used for identification
  and management purposes in partner dashboards and solution management interfaces.
   |

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
