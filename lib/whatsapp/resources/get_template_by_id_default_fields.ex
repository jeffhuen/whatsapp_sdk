defmodule WhatsApp.Resources.GetTemplateByIdDefaultFields do
  @moduledoc false

  @type t :: %__MODULE__{
          category: String.t() | nil,
          components: list(map()) | nil,
          id: String.t() | nil,
          language: String.t() | nil,
          name: String.t() | nil,
          status: String.t() | nil
        }
  defstruct [
    :category,
    :components,
    :id,
    :language,
    :name,
    :status
  ]
end
