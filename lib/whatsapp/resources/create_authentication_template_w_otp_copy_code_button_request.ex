defmodule WhatsApp.Resources.CreateAuthenticationTemplateWOtpCopyCodeButtonRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `category` | `String.t()` |  |
  | `components` | `list()` |  |
  | `language` | `String.t()` |  |
  | `name` | `String.t()` |  |
  """

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
