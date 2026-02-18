defmodule WhatsApp.Billing.ExtendedcreditsService do
  @moduledoc false

  @doc """
  Get credit lines

  - Endpoint reference: [Business > Extendedcredits](https://developers.facebook.com/docs/marketing-api/reference/extended-credit/)
  """
  @spec get_credit_lines(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.GetCreditLines.t()}
          | {:ok, WhatsApp.Resources.GetCreditLines.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_credit_lines(client, business_id, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{business_id}/extendedcredits",
           opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GetCreditLines)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GetCreditLines), resp}

      error ->
        error
    end
  end
end
