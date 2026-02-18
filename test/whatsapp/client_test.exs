defmodule WhatsApp.ClientTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Client

  describe "new/0" do
    test "reads access_token from application config" do
      Application.put_env(:whatsapp_sdk, :access_token, "config_token")

      on_exit(fn ->
        Application.delete_env(:whatsapp_sdk, :access_token)
      end)

      client = Client.new()
      assert client.access_token == "config_token"
    end

    test "reads all config keys from application config" do
      Application.put_env(:whatsapp_sdk, :access_token, "tok")
      Application.put_env(:whatsapp_sdk, :phone_number_id, "pn_123")
      Application.put_env(:whatsapp_sdk, :business_account_id, "waba_456")
      Application.put_env(:whatsapp_sdk, :app_secret, "secret")
      Application.put_env(:whatsapp_sdk, :api_version, "v22.0")
      Application.put_env(:whatsapp_sdk, :max_retries, 3)
      Application.put_env(:whatsapp_sdk, :open_timeout, 10_000)
      Application.put_env(:whatsapp_sdk, :read_timeout, 15_000)
      Application.put_env(:whatsapp_sdk, :telemetry_enabled, false)
      Application.put_env(:whatsapp_sdk, :finch, MyApp.Finch)

      on_exit(fn ->
        for key <- [
              :access_token,
              :phone_number_id,
              :business_account_id,
              :app_secret,
              :api_version,
              :max_retries,
              :open_timeout,
              :read_timeout,
              :telemetry_enabled,
              :finch
            ] do
          Application.delete_env(:whatsapp_sdk, key)
        end
      end)

      client = Client.new()
      assert client.access_token == "tok"
      assert client.phone_number_id == "pn_123"
      assert client.business_account_id == "waba_456"
      assert client.app_secret == "secret"
      assert client.api_version == "v22.0"
      assert client.max_retries == 3
      assert client.open_timeout == 10_000
      assert client.read_timeout == 15_000
      assert client.telemetry_enabled == false
      assert client.finch == MyApp.Finch
    end

    test "uses defaults for unset config keys" do
      Application.delete_env(:whatsapp_sdk, :access_token)

      client = Client.new()
      assert client.access_token == nil
      assert client.api_version == "v23.0"
      assert client.max_retries == 0
      assert client.open_timeout == 30_000
      assert client.read_timeout == 30_000
      assert client.telemetry_enabled == true
      assert client.finch == WhatsApp.Finch
      assert client.user_agent_extensions == []
    end
  end

  describe "new/2" do
    test "sets access_token from first argument" do
      client = Client.new("my_token")
      assert client.access_token == "my_token"
    end

    test "sets options from keyword list" do
      client =
        Client.new("my_token",
          phone_number_id: "pn_123",
          business_account_id: "waba_456",
          api_version: "v22.0",
          max_retries: 5
        )

      assert client.access_token == "my_token"
      assert client.phone_number_id == "pn_123"
      assert client.business_account_id == "waba_456"
      assert client.api_version == "v22.0"
      assert client.max_retries == 5
    end

    test "uses defaults for unset options" do
      client = Client.new("token")
      assert client.api_version == "v23.0"
      assert client.max_retries == 0
      assert client.open_timeout == 30_000
      assert client.read_timeout == 30_000
      assert client.telemetry_enabled == true
      assert client.finch == WhatsApp.Finch
      assert client.user_agent_extensions == []
    end

    test "raises on unknown keys" do
      assert_raise KeyError, fn ->
        Client.new("token", unknown_key: "value")
      end
    end

    test "supports custom finch instance" do
      client = Client.new("token", finch: MyCustomFinch)
      assert client.finch == MyCustomFinch
    end

    test "supports user_agent_extensions" do
      client = Client.new("token", user_agent_extensions: ["my-app/1.0"])
      assert client.user_agent_extensions == ["my-app/1.0"]
    end
  end

  describe "struct" do
    test "has all expected fields" do
      client = %Client{}

      assert Map.has_key?(client, :access_token)
      assert Map.has_key?(client, :phone_number_id)
      assert Map.has_key?(client, :business_account_id)
      assert Map.has_key?(client, :app_secret)
      assert Map.has_key?(client, :api_version)
      assert Map.has_key?(client, :max_retries)
      assert Map.has_key?(client, :open_timeout)
      assert Map.has_key?(client, :read_timeout)
      assert Map.has_key?(client, :telemetry_enabled)
      assert Map.has_key?(client, :finch)
      assert Map.has_key?(client, :user_agent_extensions)
    end
  end

  describe "WhatsApp.client/0 and WhatsApp.client/2 convenience" do
    test "WhatsApp.client/0 delegates to Client.new/0" do
      Application.put_env(:whatsapp_sdk, :access_token, "conv_token")
      on_exit(fn -> Application.delete_env(:whatsapp_sdk, :access_token) end)

      client = WhatsApp.client()
      assert %Client{} = client
      assert client.access_token == "conv_token"
    end

    test "WhatsApp.client/2 delegates to Client.new/2" do
      client = WhatsApp.client("explicit_token", phone_number_id: "123")
      assert %Client{} = client
      assert client.access_token == "explicit_token"
      assert client.phone_number_id == "123"
    end
  end
end
