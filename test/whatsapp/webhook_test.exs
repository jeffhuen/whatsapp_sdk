defmodule WhatsApp.WebhookTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Webhook
  alias WhatsApp.Error

  @app_secret "test_app_secret_1234"
  @verify_token "my_verify_token"

  describe "verify_subscription/2" do
    test "returns {:ok, challenge} with valid params using dot-separated keys" do
      params = %{
        "hub.mode" => "subscribe",
        "hub.verify_token" => @verify_token,
        "hub.challenge" => "1158201444"
      }

      assert {:ok, "1158201444"} = Webhook.verify_subscription(params, @verify_token)
    end

    test "returns {:ok, challenge} with Phoenix-style underscore params" do
      params = %{
        "hub_mode" => "subscribe",
        "hub_verify_token" => @verify_token,
        "hub_challenge" => "9876543210"
      }

      assert {:ok, "9876543210"} = Webhook.verify_subscription(params, @verify_token)
    end

    test "returns error when mode is not subscribe" do
      params = %{
        "hub.mode" => "unsubscribe",
        "hub.verify_token" => @verify_token,
        "hub.challenge" => "1158201444"
      }

      assert {:error, %Error{} = error} = Webhook.verify_subscription(params, @verify_token)
      assert error.message =~ "Webhook verification failed"
      assert error.is_transient == false
    end

    test "returns error when verify_token does not match" do
      params = %{
        "hub.mode" => "subscribe",
        "hub.verify_token" => "wrong_token",
        "hub.challenge" => "1158201444"
      }

      assert {:error, %Error{} = error} = Webhook.verify_subscription(params, @verify_token)
      assert error.message =~ "Webhook verification failed"
      assert error.is_transient == false
    end

    test "returns error when challenge is missing" do
      params = %{
        "hub.mode" => "subscribe",
        "hub.verify_token" => @verify_token
      }

      assert {:error, %Error{} = error} = Webhook.verify_subscription(params, @verify_token)
      assert error.message =~ "Webhook verification failed"
    end

    test "returns error when mode is nil" do
      params = %{
        "hub.verify_token" => @verify_token,
        "hub.challenge" => "1158201444"
      }

      assert {:error, %Error{} = error} = Webhook.verify_subscription(params, @verify_token)
      assert error.message =~ "Webhook verification failed"
    end
  end

  describe "valid?/3" do
    test "returns true for valid signature" do
      body = ~s({"object":"whatsapp_business_account"})
      signature = Webhook.compute_signature(body, @app_secret)
      header = "sha256=#{signature}"

      assert Webhook.valid?(body, header, @app_secret) == true
    end

    test "returns false for incorrect signature" do
      body = ~s({"object":"whatsapp_business_account"})
      header = "sha256=0000000000000000000000000000000000000000000000000000000000000000"

      assert Webhook.valid?(body, header, @app_secret) == false
    end

    test "returns false for malformed signature header without sha256= prefix" do
      body = ~s({"object":"whatsapp_business_account"})
      signature = Webhook.compute_signature(body, @app_secret)
      header = "md5=#{signature}"

      assert Webhook.valid?(body, header, @app_secret) == false
    end

    test "returns false for empty signature header" do
      body = ~s({"object":"whatsapp_business_account"})

      assert Webhook.valid?(body, "", @app_secret) == false
    end

    test "returns false for tampered body" do
      original_body = ~s({"object":"whatsapp_business_account"})
      tampered_body = ~s({"object":"tampered_data"})
      signature = Webhook.compute_signature(original_body, @app_secret)
      header = "sha256=#{signature}"

      assert Webhook.valid?(tampered_body, header, @app_secret) == false
    end
  end

  describe "compute_signature/2" do
    test "produces correct HMAC-SHA256 hex digest" do
      # Known test vector: HMAC-SHA256 of "test" with key "secret"
      # Verified via: echo -n "test" | openssl dgst -sha256 -hmac "secret"
      expected = "0329a06b62cd16b33eb6792be8c60b158d89a2ee3a876fce9a881ebb488c0914"

      assert Webhook.compute_signature("test", "secret") == expected
    end

    test "is deterministic - same input produces same output" do
      payload = ~s({"entry":[{"id":"123"}]})
      secret = "my_secret"

      sig1 = Webhook.compute_signature(payload, secret)
      sig2 = Webhook.compute_signature(payload, secret)

      assert sig1 == sig2
    end
  end

  describe "secure_compare (tested indirectly via valid?/3)" do
    test "both valid and invalid signatures complete without errors" do
      body = ~s({"test":"data"})
      valid_sig = "sha256=#{Webhook.compute_signature(body, @app_secret)}"
      invalid_sig = "sha256=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

      # Both should complete without raising
      assert Webhook.valid?(body, valid_sig, @app_secret) == true
      assert Webhook.valid?(body, invalid_sig, @app_secret) == false
    end
  end
end
