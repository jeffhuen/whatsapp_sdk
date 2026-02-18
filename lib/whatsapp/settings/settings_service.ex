defmodule WhatsApp.Settings.SettingsService do
  @moduledoc false

  @doc """
  Get phone number settings

  Retrieve current settings for a WhatsApp Business phone number.
  Returns calling settings, payload encryption settings, and data
  storage configurations.


  ## Parameters

    - `include_sip_credentials` (boolean, optional) - Include SIP credentials in the response (requires additional permissions)
  """
  @spec get_phone_number_settings(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def get_phone_number_settings(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [{:include_sip_credentials, Keyword.get(opts, :include_sip_credentials)}]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    WhatsApp.Client.request(
      client,
      :get,
      "/#{client.api_version}/#{phone_number_id}/settings",
      [params: query_params] ++ opts
    )
  end

  @doc """
  Update phone number settings

  Update various settings for a WhatsApp Business phone number.
  You can configure calling settings, user identity change settings,
  payload encryption, and data storage configurations.
  Only one feature setting can be specified per request.


  ## Examples

  ### Configure data storage

      %{"storage_configuration" => %{"enabled" => true, "region" => "us"}}

  ### Disable calling

      %{"calling" => %{"status" => "disabled"}}

  ### Disable payload encryption

      %{"payload_encryption" => %{"status" => "disabled"}}

  ### Enable SIP calling

      %{
    "calling" => %{
      "sip" => %{"status" => "enabled"},
      "srtp_key_exchange_protocol" => "DTLS-SRTP",
      "status" => "enabled"
    }
  }

  ### Enable calling with video

      %{
    "calling" => %{
      "call_icon_visibility" => "visible",
      "status" => "enabled",
      "video" => %{"status" => "enabled"}
    }
  }

  ### Enable payload encryption

      %{
    "payload_encryption" => %{
      "client_encryption_key" => "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJOUUVGQUFLQ0FRRUEzT2RoQzloK1FjYUpwUGxXWWJ0NE40NTFucFRKUHBnWAotLS0tLUVORCBQVUJMSUMgS0VZLS0tLS0=",
      "status" => "enabled"
    }
  }

  ### Enable user identity change

      %{"user_identity_change" => %{"enabled" => true}}
  """
  @spec update_phone_number_settings(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.UpdatePhoneNumberSettings.t()}
          | {:ok, WhatsApp.Resources.UpdatePhoneNumberSettings.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def update_phone_number_settings(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/settings",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UpdatePhoneNumberSettings)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UpdatePhoneNumberSettings),
         resp}

      error ->
        error
    end
  end
end
