defmodule WhatsApp.Resources.VideoParameter do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `video` |
  """

  @type t :: %__MODULE__{
          type: term(),
          video: map()
        }
  @enforce_keys [:type, :video]
  defstruct [
    :type,
    :video
  ]
end
