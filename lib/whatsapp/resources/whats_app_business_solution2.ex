defmodule WhatsApp.Resources.WhatsAppBusinessSolution2 do
  @moduledoc """
  Multi-Partner Solution details after rejecting deactivation request

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the Multi-Partner Solution |
  | `name` | `String.t()` | Human-readable name of the Multi-Partner Solution |
  | `owner_app` | `map()` | Meta application that owns the Multi-Partner Solution |
  | `owner_permissions` | `list()` | List of WhatsApp Business Account permissions granted to the solution owner |
  | `status` | `String.t()` | Current effective status of the Multi-Partner Solution |
  | `status_for_pending_request` | `String.t()` | Status of any pending solution status transition requests |

  ## `status` Values
  | Value |
  | --- |
  | `DRAFT` |
  | `INITIATED` |
  | `ACTIVE` |
  | `REJECTED` |
  | `DEACTIVATED` |

  ## `status_for_pending_request` Values
  | Value |
  | --- |
  | `PENDING_ACTIVATION` |
  | `PENDING_DEACTIVATION` |
  | `NONE` |

  ## `name` Constraints

  - Minimum length: 2
  - Maximum length: 75
  """

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          owner_app: map() | nil,
          owner_permissions: list(term()) | nil,
          status: String.t(),
          status_for_pending_request: String.t()
        }
  @enforce_keys [:id, :name, :status, :status_for_pending_request]
  defstruct [
    :id,
    :name,
    :owner_app,
    :owner_permissions,
    :status,
    :status_for_pending_request
  ]
end
