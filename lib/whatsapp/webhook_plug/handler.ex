defmodule WhatsApp.WebhookPlug.Handler do
  @moduledoc """
  Behaviour for WhatsApp webhook event handlers.

  Implement this behaviour to process incoming webhook events from the
  WhatsApp Business API. Each event corresponds to a `"value"` entry
  from the webhook payload's `"changes"` list.

  ## Example

      defmodule MyApp.WhatsAppHandler do
        @behaviour WhatsApp.WebhookPlug.Handler

        @impl true
        def handle_event(%{"messages" => messages} = _event) do
          Enum.each(messages, &process_message/1)
          :ok
        end

        def handle_event(_event), do: :ok

        defp process_message(message) do
          # Handle the message
          IO.inspect(message, label: "Received WhatsApp message")
        end
      end
  """

  @doc """
  Called for each webhook event received from the WhatsApp Business API.

  The `event` map is the `"value"` from each change entry in the webhook
  payload. It typically contains keys like `"messages"`, `"statuses"`,
  `"contacts"`, `"metadata"`, etc.

  Return `:ok` on success or `{:error, reason}` on failure. Note that
  returning an error does not change the HTTP response sent to Meta
  (which is always 200 to acknowledge receipt).
  """
  @callback handle_event(event :: map()) :: :ok | {:error, term()}
end
