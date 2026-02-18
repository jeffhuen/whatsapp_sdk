defmodule WhatsApp.Resources.BusinessPartner do
  @moduledoc """
  Business entity that has partner access to the pre-verified phone number

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
