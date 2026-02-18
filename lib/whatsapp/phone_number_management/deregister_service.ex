defmodule WhatsApp.PhoneNumberManagement.DeregisterService do
  @moduledoc """
  APIs for managing WhatsApp Business phone number registration and deregistration
  """

  @doc """
  Deregister WhatsApp Business Phone Number

  Deregister a WhatsApp Business phone number from the Facebook Hosted System.
  This operation removes the phone number from the WhatsApp Business Platform
  and makes it available for re-registration if needed.


  **Important Notes:**
  - Phone number must be currently linked in Facebook Hosted System
  - Phone number must be registered on the WhatsApp Business Platform
  - Cannot deregister phone numbers associated with SMB accounts
  - Rate limiting is enforced to prevent abuse
  - Deregistration triggers activity logging for audit purposes


  **Rate Limiting:**
  Standard Graph API rate limits apply with additional restrictions for registration
  operations. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Deregistration status changes are immediate and should not be cached.

  """
  @spec deregister_phone_number(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Resources.Deregister.t()}
          | {:ok, WhatsApp.Resources.Deregister.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def deregister_phone_number(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/deregister",
           opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Deregister)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Deregister), resp}

      error ->
        error
    end
  end
end
