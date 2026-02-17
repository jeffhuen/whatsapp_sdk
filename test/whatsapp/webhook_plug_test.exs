defmodule WhatsApp.WebhookPlugTest do
  use ExUnit.Case, async: true

  import Plug.Test
  import Plug.Conn

  @app_secret "test_secret"
  @verify_token "test_verify_token"

  defmodule TestHandler do
    @behaviour WhatsApp.WebhookPlug.Handler

    @impl true
    def handle_event(event) do
      send(self(), {:webhook_event, event})
      :ok
    end
  end

  @plug_opts WhatsApp.WebhookPlug.init(
               app_secret: @app_secret,
               verify_token: @verify_token,
               handler: TestHandler
             )

  # -- Helpers ---------------------------------------------------------------

  defp sign(body) do
    "sha256=" <> WhatsApp.Webhook.compute_signature(body, @app_secret)
  end

  defp webhook_body(entries) do
    JSON.encode!(%{
      "object" => "whatsapp_business_account",
      "entry" => entries
    })
  end

  # -- init/1 ----------------------------------------------------------------

  describe "init/1" do
    test "extracts required options into a map" do
      opts =
        WhatsApp.WebhookPlug.init(
          app_secret: "secret",
          verify_token: "token",
          handler: TestHandler
        )

      assert opts == %{app_secret: "secret", verify_token: "token", handler: TestHandler}
    end

    test "raises on missing app_secret" do
      assert_raise KeyError, ~r/app_secret/, fn ->
        WhatsApp.WebhookPlug.init(verify_token: "token", handler: TestHandler)
      end
    end

    test "raises on missing verify_token" do
      assert_raise KeyError, ~r/verify_token/, fn ->
        WhatsApp.WebhookPlug.init(app_secret: "secret", handler: TestHandler)
      end
    end

    test "raises on missing handler" do
      assert_raise KeyError, ~r/handler/, fn ->
        WhatsApp.WebhookPlug.init(app_secret: "secret", verify_token: "token")
      end
    end
  end

  # -- GET subscription verification ----------------------------------------

  describe "GET subscription verification" do
    test "returns 200 with challenge on valid subscription params" do
      conn =
        conn(
          :get,
          "/webhook?hub.mode=subscribe&hub.verify_token=#{@verify_token}&hub.challenge=1158201444"
        )
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 200
      assert conn.resp_body == "1158201444"
    end

    test "returns 403 on invalid verify token" do
      conn =
        conn(
          :get,
          "/webhook?hub.mode=subscribe&hub.verify_token=wrong_token&hub.challenge=1158201444"
        )
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 403
      assert conn.resp_body == "Verification failed"
    end

    test "returns 403 on missing hub.mode" do
      conn =
        conn(
          :get,
          "/webhook?hub.verify_token=#{@verify_token}&hub.challenge=1158201444"
        )
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 403
      assert conn.resp_body == "Verification failed"
    end

    test "returns 403 on wrong hub.mode" do
      conn =
        conn(
          :get,
          "/webhook?hub.mode=unsubscribe&hub.verify_token=#{@verify_token}&hub.challenge=1158201444"
        )
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 403
      assert conn.resp_body == "Verification failed"
    end

    test "returns 403 on missing challenge" do
      conn =
        conn(
          :get,
          "/webhook?hub.mode=subscribe&hub.verify_token=#{@verify_token}"
        )
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 403
      assert conn.resp_body == "Verification failed"
    end
  end

  # -- POST event delivery ---------------------------------------------------

  describe "POST event delivery" do
    test "returns 200 and dispatches events on valid signature" do
      body =
        webhook_body([
          %{
            "id" => "123456",
            "changes" => [
              %{
                "field" => "messages",
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{"phone_number_id" => "1234"},
                  "messages" => [%{"id" => "msg1", "type" => "text"}]
                }
              }
            ]
          }
        ])

      conn =
        conn(:post, "/webhook", body)
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", sign(body))
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 200
      assert conn.resp_body == "OK"
    end

    test "handler receives extracted event values" do
      value = %{
        "messaging_product" => "whatsapp",
        "metadata" => %{"phone_number_id" => "1234"},
        "messages" => [%{"id" => "msg1", "type" => "text", "text" => %{"body" => "hello"}}]
      }

      body =
        webhook_body([
          %{
            "id" => "entry1",
            "changes" => [%{"field" => "messages", "value" => value}]
          }
        ])

      conn(:post, "/webhook", body)
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-hub-signature-256", sign(body))
      |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert_received {:webhook_event, ^value}
    end

    test "returns 403 on invalid signature" do
      body = webhook_body([%{"id" => "123", "changes" => []}])

      conn =
        conn(:post, "/webhook", body)
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", "sha256=invalid")
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 403
      assert conn.resp_body == "Invalid signature"
    end

    test "returns 403 on missing signature header" do
      body = webhook_body([%{"id" => "123", "changes" => []}])

      conn =
        conn(:post, "/webhook", body)
        |> put_req_header("content-type", "application/json")
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 403
      assert conn.resp_body == "Invalid signature"
    end

    test "handles webhook body with multiple entries and changes" do
      value1 = %{"messaging_product" => "whatsapp", "event" => "message1"}
      value2 = %{"messaging_product" => "whatsapp", "event" => "status1"}
      value3 = %{"messaging_product" => "whatsapp", "event" => "message2"}

      body =
        webhook_body([
          %{
            "id" => "entry1",
            "changes" => [
              %{"field" => "messages", "value" => value1},
              %{"field" => "statuses", "value" => value2}
            ]
          },
          %{
            "id" => "entry2",
            "changes" => [
              %{"field" => "messages", "value" => value3}
            ]
          }
        ])

      conn(:post, "/webhook", body)
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-hub-signature-256", sign(body))
      |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert_received {:webhook_event, ^value1}
      assert_received {:webhook_event, ^value2}
      assert_received {:webhook_event, ^value3}
    end

    test "reads raw body from conn.assigns when available" do
      value = %{"messaging_product" => "whatsapp", "event" => "from_assigns"}

      body =
        webhook_body([
          %{
            "id" => "entry1",
            "changes" => [%{"field" => "messages", "value" => value}]
          }
        ])

      # Simulate a Phoenix setup where body has already been read
      # and raw_body is stored in assigns
      conn =
        conn(:post, "/webhook", "")
        |> put_req_header("content-type", "application/json")
        |> put_req_header("x-hub-signature-256", sign(body))
        |> Plug.Conn.assign(:raw_body, body)
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 200
      assert_received {:webhook_event, ^value}
    end
  end

  # -- Other methods ---------------------------------------------------------

  describe "unsupported methods" do
    test "returns 405 on PUT" do
      conn =
        conn(:put, "/webhook", "")
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 405
      assert conn.resp_body == "Method Not Allowed"
    end

    test "returns 405 on DELETE" do
      conn =
        conn(:delete, "/webhook")
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 405
      assert conn.resp_body == "Method Not Allowed"
    end

    test "returns 405 on PATCH" do
      conn =
        conn(:patch, "/webhook", "")
        |> WhatsApp.WebhookPlug.call(@plug_opts)

      assert conn.status == 405
      assert conn.resp_body == "Method Not Allowed"
    end
  end
end
