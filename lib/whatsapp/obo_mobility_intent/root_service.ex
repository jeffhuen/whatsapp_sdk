defmodule WhatsApp.OboMobilityIntent.RootService do
  @moduledoc """
  APIs for managing On-Behalf-Of mobility intent operations for WhatsApp Business Accounts
  """

  @doc """
  Get OBO Mobility Intent Details

  Retrieve details for a specific OBO Mobility Intent Node. This endpoint provides
  comprehensive information about the mobility intent, including current status,
  associated WABA and solution details, and operation history.


  **Use Cases:**
  - Monitor status of ongoing mobility operations
  - Retrieve mobility intent configuration details
  - Audit mobility operation progress
  - Verify operation parameters and settings


  **Response Fields:**
  The response includes the complete OBO Mobility Intent Node with all available
  fields including id, waba, solution, status, and timestamps.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields (id, waba, solution) will be returned.

  """
  @spec get_obo_mobility_intent(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.OBOMobilityIntentNode.t()}
          | {:ok, WhatsApp.Resources.OBOMobilityIntentNode.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_obo_mobility_intent(client, obo_mobility_intent_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{obo_mobility_intent_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.OBOMobilityIntentNode)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.OBOMobilityIntentNode),
         resp}

      error ->
        error
    end
  end
end
