defmodule WhatsApp.IndividualQrCode.MessageQrdlsService do
  @moduledoc """
  APIs for retrieving and deleting individual WhatsApp Business message QR codes
  """

  @doc """
  Delete Individual Message QR Code

  Permanently delete a specific QR code. Once deleted, the QR code and deep link become invalid.
  Deletion cannot be undone and affects any existing marketing materials using the QR code.

  """
  @spec delete_individual_qr_code(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.DeleteQrCode.t()}
          | {:ok, WhatsApp.Resources.DeleteQrCode.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def delete_individual_qr_code(client, qr_code_id, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :delete,
           "/#{client.api_version}/#{phone_number_id}/message_qrdls/#{qr_code_id}",
           opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteQrCode)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteQrCode), resp}

      error ->
        error
    end
  end

  @doc """
  Get Individual Message QR Code

  Retrieve details for a specific QR code by its unique identifier.
  Supports field selection and QR image generation. Response returns QR code in data array for consistency.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. Available fields:
  - code: QR code identifier (always included)
  - prefilled_message: Pre-filled message text (always included)
  - deep_link_url: WhatsApp deep link URL (always included)
  - creation_time: Unix timestamp when QR code was created (first-party apps only)
  - qr_image_url.format(FORMAT): QR code image URL where FORMAT is SVG or PNG

  Example: "code,prefilled_message,qr_image_url.format(SVG)"

  """
  @spec get_individual_qr_code(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.QrCode.t()}
          | {:ok, WhatsApp.Resources.QrCode.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_individual_qr_code(client, qr_code_id, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{phone_number_id}/message_qrdls/#{qr_code_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.QrCode)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.QrCode), resp}

      error ->
        error
    end
  end
end
