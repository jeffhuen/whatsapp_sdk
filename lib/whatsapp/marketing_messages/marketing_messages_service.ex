defmodule WhatsApp.MarketingMessages.MarketingMessagesService do
  @moduledoc """
  Send marketing template messages to WhatsApp users using pre-approved templates.
  """

  @doc """
  Send Marketing Template Message

  Send marketing template messages using pre-approved templates. Supports optional product policy controls and message activity sharing settings.

  ## Examples

  ### Template message with parameters

      %{
    "message_activity_sharing" => false,
    "messaging_product" => "whatsapp",
    "product_policy" => "STRICT",
    "recipient_type" => "individual",
    "template" => %{
      "components" => [
        %{
          "parameters" => [
            %{"text" => "John Doe", "type" => "text"},
            %{
              "currency" => %{
                "amount_1000" => 25000,
                "code" => "USD",
                "fallback_value" => "$25.00"
              },
              "type" => "currency"
            }
          ],
          "type" => "body"
        }
      ],
      "language" => %{"code" => "en"},
      "name" => "promotional_offer"
    },
    "to" => "16315552222",
    "type" => "template"
  }

  ### Basic marketing template message

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "template" => %{"language" => %{"code" => "en"}, "name" => "hello_world"},
    "to" => "16315552222",
    "type" => "template"
  }

  ### Template message with optional product policy

      %{
    "message_activity_sharing" => true,
    "messaging_product" => "whatsapp",
    "product_policy" => "CLOUD_API_FALLBACK",
    "recipient_type" => "individual",
    "template" => %{"language" => %{"code" => "en_US"}, "name" => "welcome_offer"},
    "to" => "16315552222",
    "type" => "template"
  }
  """
  @spec send_marketing_message(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.MarketingMessageResponsePayload.t()}
          | {:ok, WhatsApp.Resources.MarketingMessageResponsePayload.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def send_marketing_message(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/marketing_messages",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.MarketingMessageResponsePayload
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.MarketingMessageResponsePayload
         ), resp}

      error ->
        error
    end
  end
end
