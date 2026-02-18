defmodule WhatsApp.WhatsappBusinessBot.RootService do
  @moduledoc """
  APIs for managing WhatsApp Business Bot configuration and details
  """

  @doc """
  Get WhatsApp Business Bot Details

  Retrieve comprehensive details about a WhatsApp Business Bot, including its prompts,
  commands, and welcome message configuration.


  **Use Cases:**
  - Retrieve bot configuration and automated response settings
  - Monitor available bot commands and their descriptions
  - Check welcome message enablement status
  - Validate bot state before implementing automation
  - Audit bot configuration for business compliance


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Bot details can be cached for moderate periods, but configuration may change
  when bot settings are updated. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (prompts, commands, enable_welcome_message).
  Available fields: id, prompts, commands, enable_welcome_message

  """
  @spec get_whats_app_business_bot_details(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessBot.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessBot.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_whats_app_business_bot_details(client, waba_bot_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{waba_bot_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessBot)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessBot),
         resp}

      error ->
        error
    end
  end
end
