defmodule WhatsApp.TestStubsTest do
  use ExUnit.Case, async: true

  describe "stub/1 and fetch_fun/0" do
    test "registers and retrieves a stub function" do
      WhatsApp.Test.stub(fn _request ->
        %{status: 200, body: "{}", headers: []}
      end)

      assert {:ok, fun} = WhatsApp.Test.fetch_fun()
      assert is_function(fun, 1)

      response = fun.(%{method: :get, url: "http://test", headers: [], body: nil})
      assert response.status == 200
    end

    test "returns :error when no stub registered" do
      # Run in a separate process that has no stub and no $callers pointing here
      task =
        Task.async(fn ->
          # Clear $callers so this process is fully isolated
          Process.put(:"$callers", [])
          WhatsApp.Test.fetch_fun()
        end)

      assert :error = Task.await(task)
    end

    test "stubs are isolated between test processes" do
      WhatsApp.Test.stub(fn _req -> %{status: 200, body: "parent", headers: []} end)

      task =
        Task.async(fn ->
          # Clear $callers so the child cannot see the parent's stub
          Process.put(:"$callers", [])
          WhatsApp.Test.stub(fn _req -> %{status: 404, body: "child", headers: []} end)

          {:ok, fun} = WhatsApp.Test.fetch_fun()
          fun.(%{method: :get, url: "", headers: [], body: nil})
        end)

      child_response = Task.await(task)
      assert child_response.status == 404
      assert child_response.body == "child"

      {:ok, parent_fun} = WhatsApp.Test.fetch_fun()
      parent_response = parent_fun.(%{method: :get, url: "", headers: [], body: nil})
      assert parent_response.status == 200
      assert parent_response.body == "parent"
    end

    test "re-stubbing replaces previous stub" do
      WhatsApp.Test.stub(fn _req -> %{status: 200, body: "first", headers: []} end)
      WhatsApp.Test.stub(fn _req -> %{status: 201, body: "second", headers: []} end)

      {:ok, fun} = WhatsApp.Test.fetch_fun()
      response = fun.(%{method: :get, url: "", headers: [], body: nil})
      assert response.status == 201
      assert response.body == "second"
    end
  end

  describe "allow/1" do
    test "child Task inherits stub through $callers chain" do
      WhatsApp.Test.stub(fn _req -> %{status: 200, body: "inherited", headers: []} end)

      task =
        Task.async(fn ->
          # Task.async automatically sets $callers to include the parent
          WhatsApp.Test.fetch_fun()
        end)

      assert {:ok, fun} = Task.await(task)
      response = fun.(%{method: :get, url: "", headers: [], body: nil})
      assert response.body == "inherited"
    end

    test "allow/1 explicitly allows a non-child process" do
      WhatsApp.Test.stub(fn _req -> %{status: 200, body: "explicit", headers: []} end)

      {:ok, agent} = Agent.start_link(fn -> nil end)
      WhatsApp.Test.allow(agent)

      result =
        Agent.get(agent, fn _state ->
          WhatsApp.Test.fetch_fun()
        end)

      assert {:ok, fun} = result
      response = fun.(%{method: :get, url: "", headers: [], body: nil})
      assert response.body == "explicit"

      Agent.stop(agent)
    end
  end

  describe "stub function contract" do
    test "stub receives request map with expected keys" do
      ref = make_ref()
      test_pid = self()

      WhatsApp.Test.stub(fn request ->
        send(test_pid, {ref, request})
        %{status: 200, body: "{}", headers: []}
      end)

      {:ok, fun} = WhatsApp.Test.fetch_fun()

      request = %{
        method: :post,
        url: "https://graph.facebook.com/v23.0/123/messages",
        headers: [{"authorization", "Bearer token"}],
        body: ~s({"to":"1234"})
      }

      fun.(request)

      assert_receive {^ref, req}
      assert req.method == :post
      assert req.url == "https://graph.facebook.com/v23.0/123/messages"
      assert is_list(req.headers)
      assert is_binary(req.body)
    end

    test "stub can return different responses based on request" do
      WhatsApp.Test.stub(fn request ->
        case request.method do
          :get ->
            %{status: 200, body: ~s({"data":"found"}), headers: []}

          :post ->
            %{status: 201, body: ~s({"messages":[{"id":"wamid.abc"}]}), headers: []}

          _ ->
            %{status: 405, body: ~s({"error":"method not allowed"}), headers: []}
        end
      end)

      {:ok, fun} = WhatsApp.Test.fetch_fun()

      get_resp = fun.(%{method: :get, url: "/test", headers: [], body: nil})
      assert get_resp.status == 200

      post_resp = fun.(%{method: :post, url: "/test", headers: [], body: "{}"})
      assert post_resp.status == 201

      delete_resp = fun.(%{method: :delete, url: "/test", headers: [], body: nil})
      assert delete_resp.status == 405
    end
  end
end
