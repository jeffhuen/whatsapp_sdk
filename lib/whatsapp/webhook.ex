defmodule WhatsApp.Webhook do
  @moduledoc """
  Webhook verification and signature validation for the WhatsApp Business API.

  Meta sends webhook events as HTTP POST requests with an HMAC-SHA256
  signature in the `X-Hub-Signature-256` header. This module provides
  functions to verify subscription requests and validate incoming payloads.

  ## Subscription Verification

  When you configure a webhook URL, Meta sends a GET request with query
  parameters to verify your endpoint:

      case WhatsApp.Webhook.verify_subscription(params, "my_verify_token") do
        {:ok, challenge} -> send_resp(conn, 200, challenge)
        {:error, _error} -> send_resp(conn, 403, "Forbidden")
      end

  ## Signature Validation

      if WhatsApp.Webhook.valid?(raw_body, signature_header, app_secret) do
        # process the event
      end
  """

  alias WhatsApp.Error

  @doc """
  Verify a webhook subscription request.

  Meta sends a GET request with query parameters when verifying a webhook URL.
  The parameters may use dot notation (`hub.mode`) or underscore notation
  (`hub_mode`) depending on the framework.

  Returns `{:ok, challenge}` if the parameters are valid, or
  `{:error, %WhatsApp.Error{}}` otherwise.

  ## Parameters

    * `params` - Query parameters map from the GET request
    * `verify_token` - The verify token you configured in the Meta dashboard

  ## Examples

      iex> params = %{"hub.mode" => "subscribe", "hub.verify_token" => "tok", "hub.challenge" => "123"}
      iex> {:ok, "123"} = WhatsApp.Webhook.verify_subscription(params, "tok")

  """
  @spec verify_subscription(map(), String.t()) :: {:ok, String.t()} | {:error, Error.t()}
  def verify_subscription(params, verify_token) when is_map(params) and is_binary(verify_token) do
    mode = params["hub.mode"] || params["hub_mode"]
    token = params["hub.verify_token"] || params["hub_verify_token"]
    challenge = params["hub.challenge"] || params["hub_challenge"]

    if mode == "subscribe" and token == verify_token and is_binary(challenge) do
      {:ok, challenge}
    else
      {:error, Error.webhook_verification_error("invalid or missing parameters")}
    end
  end

  @doc """
  Validate that a webhook payload was signed by Meta.

  Computes an HMAC-SHA256 digest of `raw_body` using `app_secret` as the key,
  then performs a constant-time comparison against the signature provided in
  the `X-Hub-Signature-256` header.

  ## Parameters

    * `raw_body` - The raw request body as a binary
    * `signature_header` - The value of the `X-Hub-Signature-256` header (e.g., `"sha256=abc..."`)
    * `app_secret` - Your Facebook App Secret

  ## Examples

      iex> sig = "sha256=" <> WhatsApp.Webhook.compute_signature("body", "secret")
      iex> WhatsApp.Webhook.valid?("body", sig, "secret")
      true

  """
  @spec valid?(binary(), String.t(), String.t()) :: boolean()
  def valid?(raw_body, signature_header, app_secret)
      when is_binary(raw_body) and is_binary(signature_header) and is_binary(app_secret) do
    case signature_header do
      "sha256=" <> provided_signature ->
        expected = compute_signature(raw_body, app_secret)
        secure_compare(expected, provided_signature)

      _ ->
        false
    end
  end

  @doc """
  Compute the HMAC-SHA256 signature of a payload.

  Returns the hex-encoded digest string.

  ## Parameters

    * `payload` - The raw payload to sign
    * `secret` - The secret key (your App Secret)

  ## Examples

      iex> WhatsApp.Webhook.compute_signature("test", "secret")
      "0329a06b62cd16b33eb6792be8c60b158d89a2ee3a876fce9a881ebb488c0914"

  """
  @spec compute_signature(binary(), String.t()) :: String.t()
  def compute_signature(payload, secret) when is_binary(payload) and is_binary(secret) do
    :crypto.mac(:hmac, :sha256, secret, payload)
    |> Base.encode16(case: :lower)
  end

  # Constant-time comparison to prevent timing attacks.
  @spec secure_compare(String.t(), String.t()) :: boolean()
  defp secure_compare(a, b) when is_binary(a) and is_binary(b) do
    byte_size(a) == byte_size(b) and :crypto.hash_equals(a, b)
  end
end
