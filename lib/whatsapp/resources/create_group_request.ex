defmodule WhatsApp.Resources.CreateGroupRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `description` | `String.t()` | Group description. Maximum 2048 characters. |
  | `join_approval_mode` | `String.t()` | Indicates if WhatsApp users who click the invitation link can join the group with or without being approved first.
  - approval_required: WhatsApp users must be approved via join request before they can access the group
  - auto_approve: WhatsApp users can join the group without approval
   |
  | `messaging_product` | `String.t()` | Messaging product |
  | `subject` | `String.t()` | Group subject. Maximum 128 characters. Whitespace is trimmed. |

  ## `join_approval_mode` Values
  | Value |
  | --- |
  | `approval_required` |
  | `auto_approve` |

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |

  ## `description` Constraints

  - Maximum length: 2048

  ## `subject` Constraints

  - Maximum length: 128
  """

  @type t :: %__MODULE__{
          description: String.t() | nil,
          join_approval_mode: String.t() | nil,
          messaging_product: String.t(),
          subject: String.t()
        }
  @enforce_keys [:messaging_product, :subject]
  defstruct [
    :description,
    :messaging_product,
    :subject,
    join_approval_mode: "auto_approve"
  ]
end
