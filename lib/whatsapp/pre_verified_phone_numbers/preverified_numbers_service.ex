defmodule WhatsApp.PreVerifiedPhoneNumbers.PreverifiedNumbersService do
  @moduledoc """
  APIs for managing pre-verified phone numbers for WhatsApp Business messaging
  """

  @doc """
  Get Pre-Verified Phone Numbers

  Retrieve pre-verified phone numbers available for use with the specified business.
  This endpoint provides information about phone numbers that have been pre-verified
  and are ready for immediate use with WhatsApp Business messaging operations.

  **Use Cases:**
  - Retrieve available pre-verified phone numbers for business messaging setup
  - Check verification status and availability of phone numbers
  - Monitor pre-verified phone number inventory
  - Validate phone number options before WhatsApp Business Account configuration
  - Facilitate quick business messaging setup with pre-verified numbers

  **Filtering and Pagination:**
  - Results can be filtered by verification status, availability, and country
  - Cursor-based pagination is supported for large result sets
  - Default page size is 25 items, maximum is 100 items per page

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Caching:**
  Phone number information can be cached for short periods, but availability status
  may change frequently. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, display_phone_number, verification_status).
  Available fields: id, display_phone_number, country_prefix, verification_status,
  availability_status, created_time, last_updated, supported_features, country_code, region

    - `limit` (integer, optional) - Maximum number of phone numbers to return per page. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use this to retrieve the next page of results.
  This value is provided in the 'paging' object of previous responses.

    - `before` (string, optional) - Cursor for pagination. Use this to retrieve the previous page of results.
  This value is provided in the 'paging' object of previous responses.

    - `verification_status` (, optional) - Filter results by verification status. Only phone numbers with the specified
  verification status will be returned.

    - `availability_status` (, optional) - Filter results by availability status. Only phone numbers with the specified
  availability status will be returned.

    - `country_code` (string, optional) - Filter results by country code. Only phone numbers from the specified
  country will be returned. Use ISO 3166-1 alpha-2 country codes.

  """
  @spec get_pre_verified_phone_numbers(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.PreVerifiedPhoneNumbers.t()}
          | {:ok, WhatsApp.Resources.PreVerifiedPhoneNumbers.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_pre_verified_phone_numbers(client, business_id, opts \\ []) do
    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)},
        {:verification_status, Keyword.get(opts, :verification_status)},
        {:availability_status, Keyword.get(opts, :availability_status)},
        {:country_code, Keyword.get(opts, :country_code)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{business_id}/preverified_numbers",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.PreVerifiedPhoneNumbers)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.PreVerifiedPhoneNumbers),
         resp}

      error ->
        error
    end
  end
end
