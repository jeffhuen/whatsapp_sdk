defmodule WhatsApp.Resources.BusinessOwnedObjectOnBehalfOfRequest do
  @moduledoc """
  On-behalf request details for business owned objects

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `business_owned_object` | `String.t()` | ID of the business owned object (WhatsApp Business Account) for this request |
  | `id` | `String.t()` | Unique identifier for the on-behalf request |
  | `receiving_business` | `map()` | Business entity associated with the user |
  | `requesting_business` | `map()` | Business entity associated with the user |
  | `status` | `String.t()` | Current status of the business request |

  ## `status` Values
  | Value |
  | --- |
  | `APPROVE` |
  | `DECLINE` |
  | `IN_PROGRESS` |
  | `EXPIRED` |
  | `PENDING` |
  | `CANCELED` |
  | `INVALID` |
  """

  @type t :: %__MODULE__{
          business_owned_object: String.t(),
          id: String.t(),
          receiving_business: map() | nil,
          requesting_business: map() | nil,
          status: String.t()
        }
  @enforce_keys [:id, :status, :business_owned_object]
  defstruct [
    :business_owned_object,
    :id,
    :receiving_business,
    :requesting_business,
    :status
  ]
end
