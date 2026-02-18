defmodule WhatsApp.PreVerifiedPhoneNumberSharing.SharePreverifiedNumbersService do
  @moduledoc """
  APIs for sharing pre-verified phone numbers between business entities
  """

  @doc """
  Share Pre-Verified Phone Number with Another Business

  Share a pre-verified phone number with another business entity, granting specified
  permissions for collaborative WhatsApp Business messaging operations.


  **Use Cases:**
  - Enable partner businesses to use your pre-verified phone numbers for messaging
  - Share phone number resources between parent and subsidiary businesses
  - Facilitate multi-business WhatsApp integrations with shared phone number access
  - Establish temporary or permanent phone number sharing relationships


  **Business Logic:**
  - Only businesses with appropriate ownership or sharing rights can share phone numbers
  - Shared phone numbers maintain original ownership while granting usage permissions
  - Multiple businesses can have access to the same phone number with different permission levels
  - Sharing relationships can be time-limited with automatic expiration


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Validation:**
  - Pre-verified phone number must exist and be accessible to the requesting business
  - Target business must be a valid and accessible business entity
  - Requested permissions must be valid and within the scope of allowed sharing permissions
  - Sharing operation must comply with business relationship and access control policies


  ## Examples

  ### Basic phone number sharing

      %{
    "partner_business_id" => "9876543210987654",
    "preverified_id" => "1234567890123456"
  }
  """
  @spec share_pre_verified_phone_number(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.PreVerifiedPhoneNumberShare.t()}
          | {:ok, WhatsApp.Resources.PreVerifiedPhoneNumberShare.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def share_pre_verified_phone_number(client, business_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{business_id}/share_preverified_numbers",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.PreVerifiedPhoneNumberShare)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.PreVerifiedPhoneNumberShare),
         resp}

      error ->
        error
    end
  end
end
