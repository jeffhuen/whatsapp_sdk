defmodule WhatsApp.Templates.MessageTemplatesService do
  @moduledoc false

  @doc """
  Delete template by name

  - Guide: [Message Templates](https://developers.facebook.com/docs/business-messaging/whatsapp/templates/overview)
  - Guide: [How To Monitor Quality Signals](https://developers.facebook.com/docs/whatsapp/guides/how-to-monitor-quality-signals)
  - Endpoint reference: [WhatsApp Business Account > Message Templates](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-account/message_templates/)

  ## Parameters

    - `name` (string, optional) - 
    - `hsm_id` (string, optional) - Template ID
  """
  @spec delete_template_by_name(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Resources.DeleteTemplateByName.t()}
          | {:ok, WhatsApp.Resources.DeleteTemplateByName.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def delete_template_by_name(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    query_params =
      [{:name, Keyword.get(opts, :name)}, {:hsm_id, Keyword.get(opts, :hsm_id)}]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :delete,
           "/#{client.api_version}/#{waba_id}/message_templates",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteTemplateByName)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteTemplateByName),
         resp}

      error ->
        error
    end
  end

  @doc """
  Get template by name (default fields)

  - Guide: [Message Templates](https://developers.facebook.com/docs/business-messaging/whatsapp/templates/overview)
  - Guide: [How To Monitor Quality Signals](https://developers.facebook.com/docs/whatsapp/guides/how-to-monitor-quality-signals)
  - Endpoint reference: [WhatsApp Business Account > Message Templates](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-account/message_templates/)

  ## Parameters

    - `name` (string, optional) - 
  """
  @spec get_template_by_name_default_fields(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def get_template_by_name_default_fields(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)
    query_params = [{:name, Keyword.get(opts, :name)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    WhatsApp.Client.request(
      client,
      :get,
      "/#{client.api_version}/#{waba_id}/message_templates",
      [params: query_params] ++ opts
    )
  end
end
