defmodule WhatsApp.Media.RootService do
  @moduledoc false

  @doc """
  Delete Media

  To delete media, make a **DELETE** call to the ID of the media you want to delete.

  ## Prerequisites
  - [User Access Token](https://developers.facebook.com/docs/facebook-login/access-tokens#usertokens) with **`whatsapp_business_messaging`** permission
  - Media object ID from either uploading media endpoint or media message Webhooks

  ## Parameters

    - `phone_number_id` (string, optional) - Specifies that deletion of the media  only be performed if the media belongs to the provided phone number.
  """
  @spec delete_media(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.DeleteMedia.t()}
          | {:ok, WhatsApp.Resources.DeleteMedia.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def delete_media(client, media_id, opts \\ []) do
    query_params =
      [{:phone_number_id, Keyword.get(opts, :phone_number_id)}]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :delete,
           "/#{client.api_version}/#{media_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteMedia)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteMedia), resp}

      error ->
        error
    end
  end

  @doc """
  Download Media

  Download media files using URLs obtained from media retrieval endpoints.
  Requires User Access Token with whatsapp_business_messaging permission.
  Media URLs expire after 5 minutes and must be re-retrieved if expired.
  Returns binary content with appropriate MIME type headers.

  """
  @spec download_media(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def download_media(client, media_url, opts \\ []) do
    WhatsApp.Client.request(client, :get, "/#{client.api_version}/#{media_url}", opts)
  end

  @doc """
  Retrieve Media URL

  To retrieve your media’s URL, make a **GET** call to **`/{{Media-ID}}`**. Use the returned URL to download the media file. Note that clicking this URL (i.e. performing a generic GET) will not return the media; you must include an access token. For more information, see [Download Media](https://developers.facebook.com/docs/business-messaging/whatsapp/business-phone-numbers/media#download-media).

  You can also use the optional query **`?phone_number_id`** for **`Retrieve Media URL`** and **`Delete Media`**. This parameter checks to make sure the media belongs to the phone number before retrieval or deletion.

  #### Response

  A successful response includes an object with a media URL. The URL is only valid for 5 minutes. To use this URL, see [Download Media](https://developers.facebook.com/docs/business-messaging/whatsapp/business-phone-numbers/media#download-media).

  ## Parameters

    - `phone_number_id` (string, optional) - Specifies that this action only be performed if the media belongs to the provided phone number.
  """
  @spec retrieve_media_url(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.RetrieveMediaUrl.t()}
          | {:ok, WhatsApp.Resources.RetrieveMediaUrl.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def retrieve_media_url(client, media_id, opts \\ []) do
    query_params =
      [{:phone_number_id, Keyword.get(opts, :phone_number_id)}]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{media_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.RetrieveMediaUrl)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.RetrieveMediaUrl), resp}

      error ->
        error
    end
  end
end
