defmodule WhatsApp.Resources.TemplateObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `components` | `list()` | Array of `components` objects containing the parameters of the message. |
  | `language` | `map()` |  |
  | `name` | `String.t()` | Name of the template. |
  """

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
