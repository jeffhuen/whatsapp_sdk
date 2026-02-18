defmodule WhatsApp.Media.MediaService do
  @moduledoc false

  @doc """
  Upload Image

  This request uploads an image as .jpeg. The parameters are specified as **form-data** in the request **body**.

  ## Examples

  ### Upload Audio

      %{"file" => "@/local/path/file.ogg;type=ogg", "messaging_product" => "whatsapp"}

  ### Upload Image

      %{
    "file" => "@/local/path/file.jpg;type=image/jpeg",
    "messaging_product" => "whatsapp"
  }

  ### Upload Sticker

      %{
    "file" => "@/local/path/file.webp;type=webp",
    "messaging_product" => "whatsapp"
  }
  """
  @spec upload_image(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.UploadImage.t()}
          | {:ok, WhatsApp.Resources.UploadImage.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def upload_image(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/media",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UploadImage)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UploadImage), resp}

      error ->
        error
    end
  end
end
