defmodule WhatsApp.Resources.WhatsAppBusinessAccount1 do
  @moduledoc """
  WhatsApp Business Account owned by the business

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the WhatsApp Business Account |
  | `message_template_namespace` | `String.t()` | Namespace identifier for message templates associated with this account |
  | `name` | `String.t()` | Human-readable name of the WhatsApp Business Account |
  | `timezone_id` | `String.t()` | Timezone identifier for the WhatsApp Business Account |

  ## `name` Constraints

  - Minimum length: 1
  - Maximum length: 100
  """

  @type t :: %__MODULE__{
          id: String.t(),
          message_template_namespace: String.t(),
          name: String.t(),
          timezone_id: String.t()
        }
  @enforce_keys [:id, :name, :message_template_namespace, :timezone_id]
  defstruct [
    :id,
    :message_template_namespace,
    :name,
    :timezone_id
  ]
end
