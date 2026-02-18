defmodule WhatsApp.Resources.ConnectedClientBusiness do
  @moduledoc """
  Connected client business information and configuration

  ## `business_status` Values
  | Value |
  | --- |
  | `ACTIVE` |
  | `INACTIVE` |
  | `SUSPENDED` |
  | `PENDING_APPROVAL` |

  ## `verification_status` Values
  | Value |
  | --- |
  | `VERIFIED` |
  | `UNVERIFIED` |
  | `PENDING` |
  | `REJECTED` |

  ## `name` Constraints

  - Minimum length: 1
  - Maximum length: 255
  """

  @type t :: %__MODULE__{
          business_status: String.t() | nil,
          created_time: DateTime.t() | nil,
          id: String.t(),
          name: String.t(),
          updated_time: DateTime.t() | nil,
          verification_status: String.t() | nil
        }
  @enforce_keys [:id, :name]
  defstruct [
    :business_status,
    :created_time,
    :id,
    :name,
    :updated_time,
    :verification_status
  ]
end
