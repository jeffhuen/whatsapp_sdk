defmodule WhatsApp.PreVerifiedPhoneNumbers.RootService do
  @moduledoc """
  APIs for managing pre-verified phone numbers for WhatsApp Business messaging
  """

  @doc """
  Delete Pre-Verified Phone Number

  Delete a pre-verified phone number from the system. This operation removes the
  phone number from your pre-verified list and cannot be undone.


  **Use Cases:**
  - Remove phone numbers that are no longer needed
  - Clean up invalid or incorrect pre-verified phone numbers
  - Manage phone number lifecycle and cleanup


  **Important Notes:**
  - This operation is irreversible
  - Deleted phone numbers cannot be recovered
  - Ensure the phone number is not in active use before deletion


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  """
  @spec delete_pre_verified_phone_number(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.DeletePreVerifiedPhoneNumber.t()}
          | {:ok, WhatsApp.Resources.DeletePreVerifiedPhoneNumber.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def delete_pre_verified_phone_number(client, pre_verified_phone_number_id, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :delete,
           "/#{client.api_version}/#{pre_verified_phone_number_id}",
           opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeletePreVerifiedPhoneNumber)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeletePreVerifiedPhoneNumber),
         resp}

      error ->
        error
    end
  end

  @doc """
  Get Pre-Verified Phone Number Details

  Retrieve details about a specific pre-verified phone number, including validation
  status, formatting information, and any associated error messages.


  **Use Cases:**
  - Check validation status of a pre-verified phone number
  - Retrieve formatted display version of the phone number
  - Get country code and formatting information
  - Troubleshoot validation errors


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Phone number details can be cached for moderate periods, but validation status may
  change. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, is_input_id_valid).
  Available fields: id, country_prefix, display_phone_number, error_msg, is_input_id_valid

  """
  @spec get_pre_verified_phone_number_details(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.PreVerifiedPhoneNumberValidation.t()}
          | {:ok, WhatsApp.Resources.PreVerifiedPhoneNumberValidation.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_pre_verified_phone_number_details(client, pre_verified_phone_number_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{pre_verified_phone_number_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.PreVerifiedPhoneNumberValidation
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.PreVerifiedPhoneNumberValidation
         ), resp}

      error ->
        error
    end
  end
end
