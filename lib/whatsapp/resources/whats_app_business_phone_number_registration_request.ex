defmodule WhatsApp.Resources.WhatsAppBusinessPhoneNumberRegistrationRequest do
  @moduledoc """
  Request payload for registering a WhatsApp Business phone number

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `backup` | `map()` | Backup data for migrating existing WhatsApp Business accounts |
  | `data_localization_region` | `String.t()` | Data localization region for message storage (deprecated in v21+) |
  | `messaging_product` | `String.t()` | Must be 'whatsapp' to indicate WhatsApp Business messaging product |
  | `meta_store_retention_minutes` | `integer()` | Message retention period in minutes (deprecated in v21+) |
  | `pin` | `String.t()` | 6-digit PIN for two-step verification setup |

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
