defmodule WhatsApp.Resources.CreateGroupRequest do
  @moduledoc """
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
