defmodule WhatsApp.Resources.BusinessPartner do
  @moduledoc """
  Business entity that has partner access to the pre-verified phone number

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `created_time` | `DateTime.t()` | ISO 8601 timestamp when the business was created |
  | `id` | `String.t()` | Unique identifier for the partner business |
  | `name` | `String.t()` | Name of the partner business |
  | `primary_page` | `String.t()` | Primary Facebook Page ID associated with the business |
  | `timezone_id` | `integer()` | Timezone identifier for the business location |
  | `two_factor_type` | `String.t()` | Two-factor authentication method configured for the business |
  | `updated_time` | `DateTime.t()` | ISO 8601 timestamp when the business was last updated |
  | `verification_status` | `String.t()` | Business verification status |

  ## `two_factor_type` Values
  | Value |
  | --- |
  | `none` |
  | `admin_required` |

  ## `verification_status` Values
  | Value |
  | --- |
  | `not_verified` |
  | `pending` |
  | `verified` |
  """

  @type t :: %__MODULE__{
          created_time: DateTime.t() | nil,
          id: String.t(),
          name: String.t(),
          primary_page: String.t() | nil,
          timezone_id: integer() | nil,
          two_factor_type: String.t() | nil,
          updated_time: DateTime.t() | nil,
          verification_status: String.t() | nil
        }
  @enforce_keys [:id, :name]
  defstruct [
    :created_time,
    :id,
    :name,
    :primary_page,
    :timezone_id,
    :two_factor_type,
    :updated_time,
    :verification_status
  ]
end
