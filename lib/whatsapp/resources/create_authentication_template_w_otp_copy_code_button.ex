defmodule WhatsApp.Resources.CreateAuthenticationTemplateWOtpCopyCodeButton do
  @moduledoc false

  @type t :: %__MODULE__{
          category: String.t() | nil,
          id: String.t() | nil,
          status: String.t() | nil
        }
  defstruct [
    :category,
    :id,
    :status
  ]
end
