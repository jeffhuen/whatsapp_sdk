defmodule WhatsApp.BusinessPortfolio.RootService do
  @moduledoc false

  @doc """
  Get Business Portfolio (Specific Fields)

  Endpoint reference: [Business](https://developers.facebook.com/docs/marketing-api/reference/business/)

  ## Parameters

    - `fields` (string, optional) - 
  """
  @spec get_business_portfolio_specific_fields(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.GetBusinessPortfolioSpecificFields.t()}
          | {:ok, WhatsApp.Resources.GetBusinessPortfolioSpecificFields.t(),
             WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_business_portfolio_specific_fields(client, business_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{business_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.GetBusinessPortfolioSpecificFields
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.GetBusinessPortfolioSpecificFields
         ), resp}

      error ->
        error
    end
  end
end
