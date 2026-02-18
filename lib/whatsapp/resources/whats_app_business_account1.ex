defmodule WhatsApp.Resources.WhatsAppBusinessAccount1 do
  @moduledoc """
  WhatsApp Business Account owned by the business

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
