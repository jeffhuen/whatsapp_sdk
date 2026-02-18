defmodule WhatsApp.MultiPartnerSolutions.AccessTokenService do
  @moduledoc """
  APIs for managing Multi-Partner Solutions that enable collaborative WhatsApp Business
  messaging between solution owners and partner applications.

  """

  @doc """
  Get Multi-Partner Solution Access Token

  Retrieve a granular BISU access token for accessing customer business resources through the Multi-Partner Solution. The token provides secure, scoped access to WhatsApp Business Accounts that have been shared with the solution.


  **Use Cases:**
  - Obtain secure access tokens for partner applications to access customer business resources
  - Enable multi-tenant partner architectures with dedicated tokens per customer business
  - Support secure API operations on shared WhatsApp Business Accounts
  - Implement proper security boundaries between different customer businesses


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Token Management:**
  Access tokens are time-limited and should be refreshed before expiration. Store tokens securely and implement proper token rotation strategies.


  ## Parameters

    - `business_id` (string, **required**) - The customer business ID for which you want to retrieve an access token. This must be
  a business that has shared a WhatsApp Business Account with your Multi-Partner Solution.

  """
  @spec get_solution_access_token(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessSolutionAccessToken.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessSolutionAccessToken.t(),
             WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_solution_access_token(client, solution_id, opts \\ []) do
    query_params =
      [{:business_id, Keyword.get(opts, :business_id)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{solution_id}/access_token",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessSolutionAccessToken
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessSolutionAccessToken
         ), resp}

      error ->
        error
    end
  end
end
