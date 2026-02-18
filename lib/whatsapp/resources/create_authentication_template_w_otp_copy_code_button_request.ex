defmodule WhatsApp.Resources.CreateAuthenticationTemplateWOtpCopyCodeButtonRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          category: String.t() | nil,
          components: list(map()) | nil,
          language: String.t() | nil,
          name: String.t() | nil
        }
  defstruct [
    :category,
    :components,
    :language,
    :name
  ]
end
