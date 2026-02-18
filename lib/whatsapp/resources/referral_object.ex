defmodule WhatsApp.Resources.ReferralObject do
  @moduledoc """
  Only included if message via a Click to WhatsApp ad.

  ## `media_type` Values
  | Value |
  | --- |
  | `image` |
  | `video` |

  ## `source_type` Values
  | Value |
  | --- |
  | `ad` |
  | `post` |
  """

  @type t :: %__MODULE__{
          body: String.t(),
          ctwa_clid: String.t(),
          headline: String.t(),
          image_url: String.t() | nil,
          media_type: String.t(),
          source_id: String.t(),
          source_type: String.t(),
          source_url: String.t(),
          thumbnail_url: String.t() | nil,
          video_url: String.t() | nil,
          welcome_message: map() | nil
        }
  @enforce_keys [:source_url, :source_id, :source_type, :body, :headline, :media_type, :ctwa_clid]
  defstruct [
    :body,
    :ctwa_clid,
    :headline,
    :image_url,
    :media_type,
    :source_id,
    :source_type,
    :source_url,
    :thumbnail_url,
    :video_url,
    :welcome_message
  ]
end
