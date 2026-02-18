defmodule WhatsApp.Resources.WhatsAppBusinessSolution1 do
  @moduledoc """
  WhatsApp Business Multi-Partner Solution object with core node fields only

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the WhatsApp Business Solution |
  | `name` | `String.t()` | Human-readable name for the solution (UGC text, 2-75 characters) |
  | `owner_permissions` | `list()` | Array of permissions granted to the solution owner |
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
          owner_permissions: list(term()) | nil,
          status: String.t(),
          status_for_pending_request: String.t()
        }
  @enforce_keys [:id, :name, :status, :status_for_pending_request]
  defstruct [
    :id,
    :name,
    :owner_permissions,
    :status,
    :status_for_pending_request
  ]
end
