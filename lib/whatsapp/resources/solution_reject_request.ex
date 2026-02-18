defmodule WhatsApp.Resources.SolutionRejectRequest do
  @moduledoc """
  Request payload for rejecting a Multi-Partner Solution request

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `partner_app_id` | `String.t()` | The app ID of the requesting partner. Required when request_type is PARTNERSHIP_REQUEST, not used for DEACTIVATION_REQUEST |
  | `rejection_reason` | `String.t()` | Optional reason for rejecting the request |
  | `request_type` | `String.t()` | Type of request being rejected |

  ## `request_type` Values
  | Value |
  | --- |
  | `PARTNERSHIP_REQUEST` |
  | `DEACTIVATION_REQUEST` |

  ## `partner_app_id` Constraints

  - Pattern: `^[0-9]+$`

  ## `rejection_reason` Constraints

  - Maximum length: 500
  """

  @type t :: %__MODULE__{
          partner_app_id: String.t() | nil,
          rejection_reason: String.t() | nil,
          request_type: String.t()
        }
  @enforce_keys [:request_type]
  defstruct [
    :partner_app_id,
    :rejection_reason,
    :request_type
  ]
end
