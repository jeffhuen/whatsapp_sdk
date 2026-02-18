defmodule WhatsApp.ConversationalAutomation.ConversationalAutomationService do
  @moduledoc """
  APIs for managing conversational automation settings and bot configurations
  """

  @doc """
  Configure Conversational Automation

  Configure conversational automation settings for a WhatsApp Business Account phone number,
  including welcome messages, conversation prompts (ice breakers), and bot commands.


  **Use Cases:**
  - Set up automated welcome messages for new customer conversations
  - Configure conversation prompts to guide customer interactions
  - Define bot commands for common customer service scenarios
  - Update existing automation settings
  - Enable or disable specific automation features


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Validation:**
  - Command names must be unique within the same phone number
  - Prompts and command descriptions must comply with WhatsApp Business policies
  - Maximum limits are enforced for prompts and commands


  ## Examples

  ### Disable all automation features

      %{"commands" => [], "enable_welcome_message" => false, "prompts" => []}

  ### Enable welcome message with conversation prompts

      %{
    "commands" => [],
    "enable_welcome_message" => true,
    "prompts" => ["How can I help you today?",
     "What product are you interested in?"]
  }

  ### Complete automation setup with all features

      %{
    "commands" => [
      %{
        "command_description" => "View our product catalog",
        "command_name" => "catalog"
      },
      %{
        "command_description" => "Check our business hours",
        "command_name" => "hours"
      },
      %{
        "command_description" => "Find our store locations",
        "command_name" => "location"
      }
    ],
    "enable_welcome_message" => true,
    "prompts" => ["Welcome! How can I assist you?",
     "Are you looking for product information?",
     "Do you need help with an existing order?"]
  }

  ### Configure bot commands for customer service

      %{
    "commands" => [
      %{
        "command_description" => "Get help with your order",
        "command_name" => "help"
      },
      %{
        "command_description" => "Check your order status",
        "command_name" => "status"
      },
      %{
        "command_description" => "Contact customer support",
        "command_name" => "support"
      }
    ],
    "enable_welcome_message" => false,
    "prompts" => []
  }
  """
  @spec configure_conversational_automation(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.ConversationalAutomation.t()}
          | {:ok, WhatsApp.Resources.ConversationalAutomation.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def configure_conversational_automation(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/conversational_automation",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ConversationalAutomation)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ConversationalAutomation),
         resp}

      error ->
        error
    end
  end
end
