defmodule WhatsApp.QrCodeCollection.MessageQrdlsService do
  @moduledoc """
  APIs for listing and creating WhatsApp Business message QR codes
  """

  @doc """
  Create or Update Message QR Code

  Create a new QR code (without code parameter) or update existing QR code (with code parameter).
  Supports optional QR image generation in PNG or SVG format.


  ## Examples

  ### Create new QR code with SVG image

      %{
    "generate_qr_image" => "SVG",
    "prefilled_message" => "Hi! I'm interested in your products. Can you help me?"
  }

  ### Create new QR code without image

      %{"prefilled_message" => "I'm interested in learning more about your business!"}

  ### Create new QR code with PNG image

      %{
    "generate_qr_image" => "PNG",
    "prefilled_message" => "Hello! I'd like to get more information about your services."
  }

  ### Update existing QR code message

      %{
    "code" => "ANED2T5QRU7HG1",
    "prefilled_message" => "Hello! I'd like to know more about your latest offers."
  }
  """
  @spec create_or_update_qr_code(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.QrCode.t()}
          | {:ok, WhatsApp.Resources.QrCode.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def create_or_update_qr_code(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/message_qrdls",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.QrCode)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.QrCode), resp}

      error ->
        error
    end
  end

  @doc """
  List All Message QR Codes

  Retrieve all message QR codes for a phone number, sorted by creation time (newest first).
  Supports field selection, filtering by code, cursor-based pagination, and QR image generation.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. Available fields:
  - code: QR code identifier (always included)
  - prefilled_message: Pre-filled message text (always included)
  - deep_link_url: WhatsApp deep link URL (always included)
  - creation_time: Unix timestamp when QR code was created (first-party apps only)
  - qr_image_url.format(FORMAT): QR code image URL where FORMAT is SVG or PNG

  Example: "code,prefilled_message,qr_image_url.format(SVG)"

    - `code` (string, optional) - Filter results to a specific QR code by its unique identifier.
  When provided, only the matching QR code will be returned (if it exists).

    - `limit` (integer, optional) - Maximum number of QR codes to return in a single response.
  Default and maximum limit is typically 25.

    - `after` (string, optional) - Cursor for pagination. Use this to get the next page of results.
  Obtain this value from the paging.cursors.after field in previous responses.

    - `before` (string, optional) - Cursor for pagination. Use this to get the previous page of results.
  Obtain this value from the paging.cursors.before field in previous responses.

  """
  @spec list_all_qr_codes(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def list_all_qr_codes(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:code, Keyword.get(opts, :code)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{phone_number_id}/message_qrdls",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.QrCode)
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.QrCode)
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `list_all_qr_codes/2` that auto-pages through all results."
  @spec stream_all_qr_codes(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_all_qr_codes(client, opts \\ []) do
    case list_all_qr_codes(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn: &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.QrCode)
        )

      error ->
        error
    end
  end
end
