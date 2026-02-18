defmodule WhatsApp.OboMobilityIntent.SetOboMobilityIntentService do
  @moduledoc """
  APIs for managing On-Behalf-Of mobility intent operations for WhatsApp Business Accounts
  """

  @doc """
  Set OBO Mobility Intent

  Set On-Behalf-Of (OBO) mobility intent for a Multi-Partner Solution associated with
  a WhatsApp Business Account. This endpoint enables solution providers to establish
  OBO relationships for managing client WhatsApp Business Accounts.


  **Use Cases:**
  - Enable solution provider management of client WABA operations
  - Establish OBO relationships for business messaging solutions
  - Configure cross-platform mobility for WhatsApp Business messaging
  - Set up solution provider access to client accounts
  - Manage client onboarding for solution provider services


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  OBO mobility intent settings are cached for performance. Changes may take a few minutes
  to propagate across all systems. Implement appropriate cache invalidation strategies.


  ## Examples

  ### Basic OBO mobility intent setup

      %{
    "app_id" => "3456789012345678",
    "client_mutation_id" => "obo_mobility_intent_mutation_123",
    "solution_id" => "2345678901234567",
    "waba_id" => "1234567890123456"
  }

  ### Complete OBO mobility intent with all parameters

      %{
    "actor_id" => "4567890123456789",
    "app_id" => "3456789012345678",
    "client_mutation_id" => "obo_mobility_intent_mutation_456",
    "solution_id" => "2345678901234567",
    "waba_id" => "1234567890123456"
  }
  """
  @spec set_obo_mobility_intent(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.SetOBOMobilityIntent.t()}
          | {:ok, WhatsApp.Resources.SetOBOMobilityIntent.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def set_obo_mobility_intent(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}/set_obo_mobility_intent",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.SetOBOMobilityIntent)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.SetOBOMobilityIntent),
         resp}

      error ->
        error
    end
  end
end
