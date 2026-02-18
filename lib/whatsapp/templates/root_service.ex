defmodule WhatsApp.Templates.RootService do
  @moduledoc false

  @doc """
  Edit template

  - Guide: [Message Templates](https://developers.facebook.com/docs/business-messaging/whatsapp/templates/overview)
  - Guide: [How To Monitor Quality Signals](https://developers.facebook.com/docs/whatsapp/guides/how-to-monitor-quality-signals)
  - Endpoint reference: [WhatsApp Message Template](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-hsm/)

  ## Examples

  ### Edit template

      %{
    "category" => "MARKETING",
    "components" => [
      %{"format" => "TEXT", "text" => "Fall Sale", "type" => "HEADER"},
      %{
        "example" => %{"body_text" => [["Mark", "FALL25"]]},
        "text" => "Hi {{1}}, our Fall Sale is on! Use promo code {{2}} Get an extra 25% off every order above $350!",
        "type" => "BODY"
      },
      %{
        "text" => "Not interested in any of our sales? Tap Stop Promotions",
        "type" => "FOOTER"
      },
      %{
        "buttons" => [%{"text" => "Stop promotions", "type" => "QUICK_REPLY"}],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "2023_april_promo"
  }
  """
  @spec edit_template(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.EditTemplate.t()}
          | {:ok, WhatsApp.Resources.EditTemplate.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def edit_template(client, template_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{template_id}",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.EditTemplate)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.EditTemplate), resp}

      error ->
        error
    end
  end

  @doc """
  Get template by ID (default fields)

  - Guide: [Message Templates](https://developers.facebook.com/docs/business-messaging/whatsapp/templates/overview)
  - Guide: [How To Monitor Quality Signals](https://developers.facebook.com/docs/whatsapp/guides/how-to-monitor-quality-signals)
  - Endpoint reference: [WhatsApp Message Template](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-hsm/)
  """
  @spec get_template_by_id_default_fields(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.GetTemplateByIdDefaultFields.t()}
          | {:ok, WhatsApp.Resources.GetTemplateByIdDefaultFields.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_template_by_id_default_fields(client, template_id, opts \\ []) do
    case WhatsApp.Client.request(client, :get, "/#{client.api_version}/#{template_id}", opts) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GetTemplateByIdDefaultFields)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GetTemplateByIdDefaultFields),
         resp}

      error ->
        error
    end
  end
end
