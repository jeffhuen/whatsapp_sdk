defmodule WhatsApp.ResponseTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Response

  describe "from_fields/2" do
    test "extracts all named header fields" do
      headers = [
        {"x-fb-trace-id", "AbC123trace"},
        {"x-fb-request-id", "req_456"},
        {"x-fb-debug", "debug_info_here"},
        {"facebook-api-version", "v23.0"},
        {"x-fb-rlafr", "rlafr_status"},
        {"x-fb-connection-quality", "EXCELLENT"},
        {"content-type", "application/json"}
      ]

      response = Response.from_fields(200, headers)

      assert response.status == 200
      assert response.trace_id == "AbC123trace"
      assert response.request_id == "req_456"
      assert response.debug == "debug_info_here"
      assert response.api_version == "v23.0"
      assert response.rate_limit_status == "rlafr_status"
      assert response.connection_quality == "EXCELLENT"
    end

    test "parses JSON-encoded x-business-use-case-usage header" do
      usage_json =
        JSON.encode!(%{
          "12345" => [
            %{"call_count" => 28, "total_cputime" => 10, "total_time" => 15}
          ]
        })

      response = Response.from_fields(200, [{"x-business-use-case-usage", usage_json}])

      assert %{"12345" => [%{"call_count" => 28}]} = response.business_use_case_usage
    end

    test "parses JSON-encoded x-app-usage header" do
      usage_json =
        JSON.encode!(%{
          "call_count" => 10,
          "total_cputime" => 5,
          "total_time" => 8
        })

      response = Response.from_fields(200, [{"x-app-usage", usage_json}])

      assert %{"call_count" => 10, "total_cputime" => 5, "total_time" => 8} =
               response.app_usage
    end

    test "returns nil for missing headers" do
      response = Response.from_fields(200, [{"content-type", "application/json"}])

      assert response.trace_id == nil
      assert response.request_id == nil
      assert response.debug == nil
      assert response.api_version == nil
      assert response.business_use_case_usage == nil
      assert response.app_usage == nil
      assert response.rate_limit_status == nil
      assert response.connection_quality == nil
    end

    test "preserves raw headers list" do
      headers = [
        {"x-fb-trace-id", "trace123"},
        {"content-type", "application/json"},
        {"x-custom-header", "custom_value"}
      ]

      response = Response.from_fields(200, headers)

      assert response.headers == headers
    end

    test "handles invalid JSON in usage headers gracefully" do
      headers = [
        {"x-business-use-case-usage", "not-valid-json"},
        {"x-app-usage", "{broken"}
      ]

      response = Response.from_fields(200, headers)

      assert response.business_use_case_usage == nil
      assert response.app_usage == nil
    end

    test "captures non-200 status codes" do
      response = Response.from_fields(429, [{"x-fb-trace-id", "trace_rate_limited"}])

      assert response.status == 429
      assert response.trace_id == "trace_rate_limited"
    end
  end
end
