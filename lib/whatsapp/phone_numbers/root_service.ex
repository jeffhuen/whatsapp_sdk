defmodule WhatsApp.PhoneNumbers.RootService do
  @moduledoc """
  APIs for managing WhatsApp Business Account phone number operations
  """

  @doc """
  Retrieve WhatsApp Business Phone Number Information

  Retrieve comprehensive information about a WhatsApp Business phone number using its unique ID (CSID).
  This endpoint provides phone number status, verification details, quality metrics, and configuration information.

  **Core Information Returned:**
  - Phone number ID and display format
  - Verification status and verified business name
  - Quality rating based on message delivery performance
  - Code verification status for two-step verification
  - Display name certification status (when requested)

  **Quality Rating System:**
  The quality rating reflects how recipients have been receiving messages from this phone number:
  - **GREEN**: High quality - messages are being delivered and engaged with well
  - **YELLOW**: Medium quality - some delivery or engagement issues detected
  - **RED**: Low quality - significant delivery or engagement problems
  - **NA**: Quality rating not yet determined (new phone numbers)

  **Display Name Status:**
  When requesting the `name_status` field, you'll receive the current certification status:
  - **APPROVED**: Business name verified and certificate available for download
  - **AVAILABLE_WITHOUT_REVIEW**: Certificate ready without additional review required
  - **DECLINED**: Business name verification rejected
  - **EXPIRED**: Existing certificate has expired and needs renewal
  - **PENDING_REVIEW**: Name verification request is under review
  - **NONE**: No certificate or verification request exists

  **Code Verification Status:**
  Indicates the two-step verification status:
  - **VERIFIED**: Phone number has completed two-step verification
  - **UNVERIFIED**: Two-step verification is pending or incomplete

  **Use Cases:**
  - Monitor phone number quality and delivery performance
  - Check verification and certification status
  - Validate phone number configuration before sending messages
  - Retrieve display information for business profiles
  - Audit phone number compliance and status

  For more information on quality ratings, see [WhatsApp Business Account Message Quality Rating](https://www.facebook.com/business/help/896873687365001).


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of additional fields to include in the response. If not specified,
  only default fields (id, display_phone_number, verified_name, quality_rating) are returned.

  **Available Fields:**
  - `name_status`: Display name certification status for business verification
  - `code_verification_status`: Two-step verification status for the phone number

  **Field Values:**

  **name_status** values:
  - `APPROVED`: Business name approved, certificate available for download
  - `AVAILABLE_WITHOUT_REVIEW`: Certificate ready without additional review
  - `DECLINED`: Business name verification rejected
  - `EXPIRED`: Certificate expired and needs renewal
  - `PENDING_REVIEW`: Name verification under review
  - `NONE`: No certificate or verification request exists

  **code_verification_status** values:
  - `VERIFIED`: Phone number has completed two-step verification
  - `UNVERIFIED`: Two-step verification pending or incomplete

  """
  @spec get_phone_number_by_id(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def get_phone_number_by_id(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    WhatsApp.Client.request(
      client,
      :get,
      "/#{client.api_version}/#{phone_number_id}",
      [params: query_params] ++ opts
    )
  end

  @doc """
  Update WhatsApp Business Account Phone Number Status and Configuration

  Update the status and configuration of a WhatsApp Business Account phone number.
  This endpoint supports comprehensive phone number management including status updates,
  webhook configuration, security settings, and business profile management.

  **Supported Operations:**
  - Update connection status between WhatsApp Business Account and phone number
  - Configure webhook endpoints for message delivery notifications
  - Set up two-step verification and security notifications
  - Update display names for name verification
  - Configure search visibility and privacy settings
  - Set username for the WhatsApp Business Account
  - Override webhook callback URIs for message notifications

  **Business Logic Requirements:**
  - App must be linked to the WhatsApp Business Account
  - Webhook subscription must exist before configuring callback URI overrides
  - Callback URI verification is performed for external URLs
  - Internal URLs are allowed for development environments

  **Rate Limiting:**
  WhatsApp use case throttling applies. Use appropriate retry logic with exponential backoff.

  **Security Validations:**
  - App-to-WABA linking validation enforced
  - Webhook callback URI verification required for external URLs
  - Business integration system user checks for AI bot onboarding
  - Capability checks for first-party app access


  ## Examples

  ### Comprehensive status and configuration update

      %{
    "connection_status" => "CONNECTED",
    "new_display_name" => "My Business Name",
    "search_visibility" => "VISIBLE",
    "username" => "mybusiness",
    "webhook_configuration" => %{
      "override_callback_uri" => "https://your-domain.com/webhook/override",
      "verify_token" => "YOUR_VERIFY_TOKEN"
    },
    "webhook_url" => "https://your-domain.com/webhook",
    "whatsapp_business_api_data" => %{
      "notify_user_change_number" => false,
      "pin" => "123456",
      "show_security_notifications" => true
    }
  }

  ### Configure webhook URL

      %{
    "webhook_configuration" => %{
      "override_callback_uri" => "https://your-domain.com/webhook/override",
      "verify_token" => "YOUR_VERIFY_TOKEN"
    },
    "webhook_url" => "https://your-domain.com/webhook"
  }

  ### Set WhatsApp Business Account username

      %{"username" => "mynewbusiness"}

  ### Update connection status

      %{"connection_status" => "CONNECTED"}

  ### Update display name for verification

      %{"new_display_name" => "My New Business Name"}

  ### Update security and notification settings

      %{
    "search_visibility" => "VISIBLE",
    "whatsapp_business_api_data" => %{
      "notify_user_change_number" => false,
      "pin" => "123456",
      "show_security_notifications" => true
    }
  }
  """
  @spec update_phone_number_status(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def update_phone_number_status(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    WhatsApp.Client.request(
      client,
      :post,
      "/#{client.api_version}/#{phone_number_id}",
      [json: params] ++ opts
    )
  end
end
