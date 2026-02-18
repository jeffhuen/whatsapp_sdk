defmodule WhatsApp.PhoneNumberManagement.PhoneNumbersService do
  @moduledoc """
  APIs for managing WhatsApp Business phone number registration and deregistration
  """

  @doc """
  Create WhatsApp Business Account Phone Number

  Create a new phone number registration within a WhatsApp Business Account. This endpoint
  initiates the phone number onboarding process, including verification and business name approval.

  **Use Cases:**
  - Add new phone numbers to a WhatsApp Business Account
  - Migrate phone numbers from on-premises to Cloud API
  - Register pre-verified phone numbers for BSP scenarios
  - Initiate phone number verification and business name approval process

  **Prerequisites:**
  - WhatsApp Business Account must have available phone number slots
  - Phone number must not be already registered with WhatsApp Business
  - Business must meet WhatsApp Business API requirements
  - Appropriate permissions and app review completion

  **Process Flow:**
  1. Submit phone number and business name for registration
  2. Phone number verification code will be sent (if not pre-verified)
  3. Business name will be submitted for review
  4. Monitor status through GET endpoint until approval

  **Rate Limiting:**
  Phone number creation is subject to strict rate limits to prevent abuse.
  Standard Graph API rate limits also apply.

  **Migration Support:**
  Set migrate_phone_number=true when migrating from on-premises API to Cloud API.
  Additional validation and migration-specific logic will be applied.


  ## Examples

  ### Basic phone number registration

      %{
    "cc" => "1",
    "phone_number" => "16315551000",
    "verified_name" => "My Business Name"
  }

  ### Phone number migration from on-premises

      %{
    "cc" => "1",
    "migrate_phone_number" => true,
    "phone_number" => "16315551001",
    "verified_name" => "Migrated Business"
  }

  ### Pre-verified phone number for BSP

      %{
    "cc" => "1",
    "phone_number" => "16315551002",
    "preverified_id" => "preverified_12345",
    "verified_name" => "BSP Business"
  }
  """
  @spec create_whats_app_business_account_phone_number(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.PhoneNumberCreate.t()}
          | {:ok, WhatsApp.Resources.PhoneNumberCreate.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def create_whats_app_business_account_phone_number(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}/phone_numbers",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.PhoneNumberCreate)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.PhoneNumberCreate), resp}

      error ->
        error
    end
  end

  @doc """
  Get WhatsApp Business Account Phone Numbers

  Retrieve all phone numbers associated with a WhatsApp Business Account, including their
  status, verification details, and configuration information.

  **Use Cases:**
  - List all phone numbers in a WhatsApp Business Account
  - Monitor phone number status and verification progress
  - Check phone number quality ratings and messaging limits
  - Retrieve phone number configuration details

  **Filtering:**
  You can filter results using the `filtering` parameter with JSON-encoded filter conditions.
  Supported filters include account_mode, messaging_limit_tier, and is_official_business_account.

  **Sorting:**
  Results can be sorted by creation_time or last_onboarded_time in ascending or descending order.

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Caching:**
  Phone number data can be cached for short periods, but status information may change
  frequently. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned. Available fields include: id, display_phone_number,
  verified_name, status, quality_rating, country_code, country_dial_code,
  code_verification_status, unified_cert_status, account_mode, host_platform,
  messaging_limit_tier, is_official_business_account, username

    - `filtering` (string, optional) - JSON-encoded array of filter conditions. Each filter should specify field, operator, and value.
  Supported fields: account_mode, messaging_limit_tier, is_official_business_account

    - `sort` (string, optional) - Sort field and direction. Format: field_name.asc or field_name.desc
  Supported fields: creation_time, last_onboarded_time

    - `limit` (integer, optional) - Maximum number of phone numbers to return per page
    - `after` (string, optional) - Cursor for pagination - retrieve records after this cursor
    - `before` (string, optional) - Cursor for pagination - retrieve records before this cursor
  """
  @spec get_whats_app_business_account_phone_numbers(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_whats_app_business_account_phone_numbers(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:filtering, Keyword.get(opts, :filtering)},
        {:sort, Keyword.get(opts, :sort)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{waba_id}/phone_numbers",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.WhatsAppBusinessAccountPhoneNumber
           )
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.WhatsAppBusinessAccountPhoneNumber
           )
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `get_whats_app_business_account_phone_numbers/2` that auto-pages through all results."
  @spec stream_whats_app_business_account_phone_numbers(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_whats_app_business_account_phone_numbers(client, opts \\ []) do
    case get_whats_app_business_account_phone_numbers(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn:
            &WhatsApp.Deserializer.deserialize(
              &1,
              WhatsApp.Resources.WhatsAppBusinessAccountPhoneNumber
            )
        )

      error ->
        error
    end
  end
end
