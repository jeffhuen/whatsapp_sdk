defmodule WhatsApp.PreVerifiedPhoneNumberPartners.PartnersService do
  @moduledoc """
  APIs for managing partner businesses associated with pre-verified phone numbers
  """

  @doc """
  Get Pre-Verified Phone Number Partners

  Retrieve the list of partner businesses that have been granted access to a specific
  WhatsApp Business Pre-Verified Phone Number.


  **Use Cases:**
  - Monitor partner business relationships and access permissions
  - Verify which businesses have access to shared pre-verified phone numbers
  - Retrieve partner business information for operational purposes
  - Validate partnership configurations before business operations


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Partner information can be cached for moderate periods, but partnership relationships
  may change. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, name). Available fields: id, name, created_time,
  updated_time, verification_status, primary_page, timezone_id, two_factor_type

    - `limit` (integer, optional) - Maximum number of partner businesses to return per page. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use the 'after' cursor from a previous response to get the next page.

    - `before` (string, optional) - Cursor for pagination. Use the 'before' cursor from a previous response to get the previous page.

  """
  @spec get_pre_verified_phone_number_partners(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessPreVerifiedPhoneNumberPartners.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessPreVerifiedPhoneNumberPartners.t(),
             WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_pre_verified_phone_number_partners(client, pre_verified_phone_number_id, opts \\ []) do
    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{pre_verified_phone_number_id}/partners",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessPreVerifiedPhoneNumberPartners
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessPreVerifiedPhoneNumberPartners
         ), resp}

      error ->
        error
    end
  end
end
