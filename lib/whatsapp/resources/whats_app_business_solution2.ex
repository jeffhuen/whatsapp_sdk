defmodule WhatsApp.Resources.WhatsAppBusinessSolution2 do
  @moduledoc """
  Multi-Partner Solution details after rejecting deactivation request

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
