defmodule WhatsApp.ErrorTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Error

  describe "from_response/2" do
    test "parses a standard Meta error response" do
      body = %{
        "error" => %{
          "message" => "Invalid OAuth access token",
          "type" => "OAuthException",
          "code" => 190,
          "error_subcode" => 463,
          "fbtrace_id" => "AbCdEf123"
        }
      }

      error = Error.from_response(401, body)

      assert %Error{} = error
      assert error.message == "Invalid OAuth access token"
      assert error.status == 401
      assert error.code == 190
      assert error.error_subcode == 463
      assert error.error_type == "OAuthException"
      assert error.fbtrace_id == "AbCdEf123"
      assert error.is_transient == false
      assert error.retry_after == nil
      assert error.details == body
    end

    test "parses a rate limit error (status 429)" do
      body = %{
        "error" => %{
          "message" => "Too many calls",
          "type" => "OAuthException",
          "code" => 80_007,
          "fbtrace_id" => "RateTrace123"
        }
      }

      error = Error.from_response(429, body)

      assert error.status == 429
      assert error.code == 80_007
      assert error.message == "Too many calls"
      assert error.is_transient == false
    end

    test "parses a transient error" do
      body = %{
        "error" => %{
          "message" => "Service temporarily unavailable",
          "type" => "GraphMethodException",
          "code" => 131_016,
          "is_transient" => true,
          "fbtrace_id" => "TransientTrace456"
        }
      }

      error = Error.from_response(500, body)

      assert error.status == 500
      assert error.code == 131_016
      assert error.is_transient == true
      assert error.fbtrace_id == "TransientTrace456"
    end

    test "handles a minimal error response with missing optional fields" do
      body = %{
        "error" => %{
          "message" => "Something went wrong"
        }
      }

      error = Error.from_response(400, body)

      assert error.message == "Something went wrong"
      assert error.status == 400
      assert error.code == nil
      assert error.error_subcode == nil
      assert error.error_type == nil
      assert error.fbtrace_id == nil
      assert error.is_transient == false
      assert error.retry_after == nil
    end

    test "handles a non-Meta error format response" do
      body = %{"message" => "Unexpected error"}

      error = Error.from_response(500, body)

      assert error.message == "Unexpected error"
      assert error.status == 500
      assert error.code == nil
      assert error.details == body
    end

    test "generates a default message when body has no message field" do
      body = %{"error" => %{"code" => 999}}

      error = Error.from_response(502, body)

      assert error.message == "HTTP 502"
      assert error.status == 502
      assert error.code == 999
    end
  end

  describe "from_response/3" do
    test "extracts Retry-After header as integer seconds" do
      body = %{
        "error" => %{
          "message" => "Rate limited",
          "type" => "OAuthException",
          "code" => 80_007
        }
      }

      headers = [
        {"content-type", "application/json"},
        {"Retry-After", "60"}
      ]

      error = Error.from_response(429, body, headers)

      assert error.retry_after == 60
      assert error.status == 429
      assert error.code == 80_007
    end

    test "handles case-insensitive Retry-After header" do
      body = %{"error" => %{"message" => "Rate limited", "code" => 4}}
      headers = [{"retry-after", "30"}]

      error = Error.from_response(429, body, headers)

      assert error.retry_after == 30
    end

    test "sets retry_after to nil when header is absent" do
      body = %{"error" => %{"message" => "Server error"}}
      headers = [{"content-type", "application/json"}]

      error = Error.from_response(500, body, headers)

      assert error.retry_after == nil
    end

    test "sets retry_after to nil when header value is not a valid integer" do
      body = %{"error" => %{"message" => "Rate limited"}}
      headers = [{"retry-after", "not-a-number"}]

      error = Error.from_response(429, body, headers)

      assert error.retry_after == nil
    end
  end

  describe "connection_error/1" do
    test "builds an error from a string reason" do
      error = Error.connection_error("connection refused")

      assert %Error{} = error
      assert error.message == "connection refused"
      assert error.status == nil
      assert error.code == nil
      assert error.is_transient == false
    end

    test "builds an error from an exception struct" do
      exception = %RuntimeError{message: "timeout"}

      error = Error.connection_error(exception)

      assert error.message == "timeout"
      assert error.status == nil
      assert error.code == nil
    end

    test "builds an error from an arbitrary term" do
      error = Error.connection_error(:econnrefused)

      assert error.message == ":econnrefused"
      assert error.status == nil
    end
  end

  describe "webhook_verification_error/1" do
    test "builds an error with a prefixed message" do
      error = Error.webhook_verification_error("token mismatch")

      assert %Error{} = error
      assert error.message == "Webhook verification failed: token mismatch"
      assert error.status == nil
      assert error.code == nil
      assert error.is_transient == false
    end
  end

  describe "retryable?/1" do
    test "returns true for 429 rate limit" do
      error = %Error{message: "rate limited", status: 429}
      assert Error.retryable?(error) == true
    end

    test "returns true for 500 server error" do
      error = %Error{message: "server error", status: 500}
      assert Error.retryable?(error) == true
    end

    test "returns true for 502 bad gateway" do
      error = %Error{message: "bad gateway", status: 502}
      assert Error.retryable?(error) == true
    end

    test "returns true for 503 service unavailable" do
      error = %Error{message: "service unavailable", status: 503}
      assert Error.retryable?(error) == true
    end

    test "returns true for is_transient: true even with 400 status" do
      error = %Error{message: "transient", status: 400, is_transient: true}
      assert Error.retryable?(error) == true
    end

    test "returns true for connection errors (no status)" do
      error = Error.connection_error("network error")
      assert error.status == nil
      assert Error.retryable?(error) == true
    end

    test "returns false for 401 unauthorized" do
      error = %Error{message: "unauthorized", status: 401}
      assert Error.retryable?(error) == false
    end

    test "returns false for 404 not found" do
      error = %Error{message: "not found", status: 404}
      assert Error.retryable?(error) == false
    end

    test "returns false for 400 bad request" do
      error = %Error{message: "bad request", status: 400}
      assert Error.retryable?(error) == false
    end

    test "returns false for 403 forbidden" do
      error = %Error{message: "forbidden", status: 403}
      assert Error.retryable?(error) == false
    end
  end

  describe "message/1" do
    test "returns the human-readable error message" do
      error = %Error{message: "Something went wrong"}
      assert Error.message(error) == "Something went wrong"
    end
  end

  describe "Exception behaviour" do
    test "can be raised" do
      assert_raise Error, "API failure", fn ->
        raise Error, message: "API failure", status: 500
      end
    end

    test "raised error has all fields preserved" do
      error =
        assert_raise Error, fn ->
          raise Error,
            message: "Token expired",
            status: 401,
            code: 190,
            error_subcode: 463,
            error_type: "OAuthException",
            fbtrace_id: "trace123"
        end

      assert error.status == 401
      assert error.code == 190
      assert error.error_subcode == 463
      assert error.error_type == "OAuthException"
      assert error.fbtrace_id == "trace123"
    end
  end
end
