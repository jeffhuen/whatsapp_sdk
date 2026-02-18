defmodule WhatsApp.BusinessPhoneNumbers.AddPhoneNumbersService do
  @moduledoc """
  APIs for managing phone numbers in WhatsApp Business Accounts
  """

  @doc """
  Add Phone Number to Business Account

  Add a preverified phone number to a WhatsApp Business Account. This endpoint is used by
  Partners to create a pool of Partner owned numbers that end clients
  can purchase.

  **Use Cases:**
  - Add new phone numbers to scale messaging operations
  - Set up phone numbers for different business locations
  - Manage phone number inventory for business messaging
  - Configure phone numbers for specific messaging workflows

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Phone Number Requirements:**
  - Must be in E.164 format (e.g., +1234567890)
  - Must not be already registered to another WhatsApp Business Account
  - Must be capable of receiving SMS for verification
  - Must comply with WhatsApp's business messaging policies


  ## Examples

  ### Add phone number with E.164 format

      %{"phone_number" => "+1234567890"}
  """
  @spec add_phone_numbers(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.AddPhoneNumbers.t()}
          | {:ok, WhatsApp.Resources.AddPhoneNumbers.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def add_phone_numbers(client, business_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{business_id}/add_phone_numbers",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.AddPhoneNumbers)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.AddPhoneNumbers), resp}

      error ->
        error
    end
  end
end
