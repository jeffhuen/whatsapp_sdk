defmodule WhatsApp.Resources.GetTemplateByIdDefaultFields do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `category` | `String.t()` |  |
  | `components` | `list()` |  |
  | `id` | `String.t()` |  |
  | `language` | `String.t()` |  |
  | `name` | `String.t()` |  |
  | `status` | `String.t()` |  |
  """

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
