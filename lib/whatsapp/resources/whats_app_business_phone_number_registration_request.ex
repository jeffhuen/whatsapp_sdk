defmodule WhatsApp.Resources.WhatsAppBusinessPhoneNumberRegistrationRequest do
  @moduledoc """
  Request payload for registering a WhatsApp Business phone number

  ## `data_localization_region` Values
  | Value |
  | --- |
  | `AE` |
  | `AU` |
  | `BH` |
  | `BR` |
  | `CA` |
  | `CH` |
  | `DE` |
  | `GB` |
  | `ID` |
  | `IN` |
  | `JP` |
  | `KR` |
  | `SG` |
  | `ZA` |

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |

  ## `meta_store_retention_minutes` Constraints

  - Minimum value: 60
  - Maximum value: 60

  ## `pin` Constraints

  - Minimum length: 6
  - Maximum length: 6
  - Pattern: `^[0-9]{6}$`
  """

  @type t :: %__MODULE__{
          backup: map() | nil,
          data_localization_region: String.t() | nil,
          messaging_product: String.t(),
          meta_store_retention_minutes: integer() | nil,
          pin: String.t()
        }
  @enforce_keys [:messaging_product, :pin]
  defstruct [
    :backup,
    :data_localization_region,
    :messaging_product,
    :meta_store_retention_minutes,
    :pin
  ]
end
