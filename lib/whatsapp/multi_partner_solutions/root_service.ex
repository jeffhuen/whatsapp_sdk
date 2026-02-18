defmodule WhatsApp.MultiPartnerSolutions.RootService do
  @moduledoc """
  APIs for managing Multi-Partner Solutions that enable collaborative WhatsApp Business
  messaging between solution owners and partner applications.

  """

  @doc """
  Get Multi-Partner Solution Details

  Retrieve comprehensive details about a Multi-Partner Solution, including its current status,
  pending status transitions, ownership information, and granted permissions.


  **Use Cases:**
  - Monitor solution lifecycle and status changes
  - Verify solution configuration before business onboarding
  - Check pending approval requests and status transitions
  - Retrieve solution ownership and permission details


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Solution details can be cached for short periods, but status information may change
  frequently during transitions. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (name, status, status_for_pending_request).
  Available fields: id, name, status, status_for_pending_request, owner_app, owner_permissions

  """
  @spec get_solution_details(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessSolution.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessSolution.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_solution_details(client, solution_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{solution_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessSolution)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessSolution),
         resp}

      error ->
        error
    end
  end
end
