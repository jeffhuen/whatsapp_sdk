defmodule WhatsApp.Resources.TemplateObject do
  @moduledoc false

  @type t :: %__MODULE__{
          components: list(WhatsApp.Resources.TemplateComponent.t()) | nil,
          language: map(),
          name: String.t()
        }
  @enforce_keys [:name, :language]
  defstruct [
    :components,
    :language,
    :name
  ]
end
