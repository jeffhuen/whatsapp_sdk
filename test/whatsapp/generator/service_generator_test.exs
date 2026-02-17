defmodule WhatsApp.Generator.ServiceGeneratorTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Generator.OpenAPI
  alias WhatsApp.Generator.ServiceGenerator

  @fixture_path Path.expand("../../fixtures/mini_spec.json", __DIR__)

  setup_all do
    spec = OpenAPI.parse(@fixture_path)
    output_dir = Path.join(System.tmp_dir!(), "sg_test_#{System.unique_integer([:positive])}")
    File.mkdir_p!(output_dir)

    generated = ServiceGenerator.generate(spec, output_dir)

    on_exit(fn -> File.rm_rf!(output_dir) end)

    %{spec: spec, output_dir: output_dir, generated: generated}
  end

  # ── 1. File creation ────────────────────────────────────────────────────

  describe "file creation" do
    test "generates correct number of service files", %{generated: generated} do
      # messages/messages, media/media, media/root, groups/groups
      assert length(generated) == 4
    end

    test "generates messages service at expected path", %{
      generated: generated,
      output_dir: output_dir
    } do
      paths = Enum.map(generated, &elem(&1, 0))
      assert "lib/whatsapp/messages/messages_service.ex" in paths

      full = Path.join(output_dir, "lib/whatsapp/messages/messages_service.ex")
      assert File.exists?(full)
    end

    test "generates media service at expected path", %{
      generated: generated,
      output_dir: output_dir
    } do
      paths = Enum.map(generated, &elem(&1, 0))
      assert "lib/whatsapp/media/media_service.ex" in paths

      full = Path.join(output_dir, "lib/whatsapp/media/media_service.ex")
      assert File.exists?(full)
    end

    test "generates media root service at expected path", %{
      generated: generated,
      output_dir: output_dir
    } do
      paths = Enum.map(generated, &elem(&1, 0))
      assert "lib/whatsapp/media/root_service.ex" in paths

      full = Path.join(output_dir, "lib/whatsapp/media/root_service.ex")
      assert File.exists?(full)
    end

    test "generates groups service at expected path", %{
      generated: generated,
      output_dir: output_dir
    } do
      paths = Enum.map(generated, &elem(&1, 0))
      assert "lib/whatsapp/groups/groups_service.ex" in paths

      full = Path.join(output_dir, "lib/whatsapp/groups/groups_service.ex")
      assert File.exists?(full)
    end

    test "returns correct module names", %{generated: generated} do
      modules = Enum.map(generated, &elem(&1, 1))
      assert "WhatsApp.Messages.MessagesService" in modules
      assert "WhatsApp.Media.MediaService" in modules
      assert "WhatsApp.Media.RootService" in modules
      assert "WhatsApp.Groups.GroupsService" in modules
    end
  end

  # ── 2. Generated modules compile ───────────────────────────────────────

  describe "compilation" do
    test "all generated files compile without errors", %{
      generated: generated,
      output_dir: output_dir
    } do
      for {path, _module_name} <- generated do
        full = Path.join(output_dir, path)
        source = File.read!(full)

        assert [{_module, _bytecode}] = Code.compile_string(source, full),
               "Failed to compile #{path}"
      end
    end
  end

  # ── 3. @moduledoc ──────────────────────────────────────────────────────

  describe "@moduledoc" do
    test "messages service has Markdown moduledoc from tag description", %{
      output_dir: output_dir
    } do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ ~s(## Send Messages)
      assert source =~ ~s(Send various types of messages.)
    end

    test "media service has plain moduledoc from tag description", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/media_service.ex")
      assert source =~ ~s(Upload and manage media.)
    end

    test "groups service has @moduledoc false for empty tag description", %{
      output_dir: output_dir
    } do
      source = read_service(output_dir, "groups/groups_service.ex")
      assert source =~ "@moduledoc false"
    end
  end

  # ── 4. Function names ──────────────────────────────────────────────────

  describe "function names" do
    test "sendMessage becomes send_message", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ "def send_message("
    end

    test "uploadMedia becomes upload_media", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/media_service.ex")
      assert source =~ "def upload_media("
    end

    test "getMediaUrl becomes get_media_url", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      assert source =~ "def get_media_url("
    end

    test "deleteMedia becomes delete_media", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      assert source =~ "def delete_media("
    end

    test "getActiveGroups becomes get_active_groups", %{output_dir: output_dir} do
      source = read_service(output_dir, "groups/groups_service.ex")
      assert source =~ "def get_active_groups("
    end
  end

  # ── 5. Path parameter interpolation ────────────────────────────────────

  describe "path parameter interpolation" do
    test "send_message path includes api_version and phone_number_id", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ ~s(\#{client.api_version})
      assert source =~ ~s(\#{phone_number_id})
      assert source =~ ~s(/messages)
    end

    test "get_media_url path includes api_version and media_id", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      assert source =~ ~s(\#{client.api_version})
      assert source =~ ~s(\#{media_id})
    end

    test "upload_media path includes api_version and phone_number_id", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/media_service.ex")
      assert source =~ ~s(\#{client.api_version})
      assert source =~ ~s(\#{phone_number_id})
      assert source =~ ~s(/media)
    end
  end

  # ── 6. Content type selection ──────────────────────────────────────────

  describe "content type selection" do
    test "send_message uses json encoding", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ "json: params"
      refute source =~ "multipart: params"
    end

    test "upload_media uses multipart encoding", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/media_service.ex")
      assert source =~ "multipart: params"
      refute source =~ "json: params"
    end

    test "get_media_url has no body encoding", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      # get_media_url should not have json/multipart/form
      get_media_fn = extract_function(source, "get_media_url")
      refute get_media_fn =~ "json:"
      refute get_media_fn =~ "multipart:"
      refute get_media_fn =~ "form:"
    end

    test "delete_media has no body encoding", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      delete_media_fn = extract_function(source, "delete_media")
      refute delete_media_fn =~ "json:"
      refute delete_media_fn =~ "multipart:"
      refute delete_media_fn =~ "form:"
    end
  end

  # ── 7. Client config vs function arg params ────────────────────────────

  describe "client config vs function arg params" do
    test "phone_number_id comes from client config with opts override", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ "Keyword.get(opts, :phone_number_id, client.phone_number_id)"
    end

    test "media_id is a function argument, not from client config", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      # media_id should be a function argument
      assert source =~ "def get_media_url(client, media_id, opts \\\\ [])"
      # media_id should NOT have a Keyword.get line
      refute source =~ "Keyword.get(opts, :media_id"
    end

    test "get_active_groups resolves phone_number_id from config", %{output_dir: output_dir} do
      source = read_service(output_dir, "groups/groups_service.ex")
      assert source =~ "Keyword.get(opts, :phone_number_id, client.phone_number_id)"
    end
  end

  # ── 8. Function signatures ─────────────────────────────────────────────

  describe "function signatures" do
    test "POST with body gets (client, params, opts)", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ "def send_message(client, params, opts \\\\ [])"
    end

    test "POST with body and multipart gets (client, params, opts)", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/media_service.ex")
      assert source =~ "def upload_media(client, params, opts \\\\ [])"
    end

    test "GET on collection gets (client, opts)", %{output_dir: output_dir} do
      source = read_service(output_dir, "groups/groups_service.ex")
      assert source =~ "def get_active_groups(client, opts \\\\ [])"
    end

    test "GET on instance gets (client, resource_id, opts)", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      assert source =~ "def get_media_url(client, media_id, opts \\\\ [])"
    end

    test "DELETE on instance gets (client, resource_id, opts)", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      assert source =~ "def delete_media(client, media_id, opts \\\\ [])"
    end
  end

  # ── 9. @spec annotations ───────────────────────────────────────────────

  describe "@spec annotations" do
    test "POST with body has correct spec", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")

      assert source =~
               "@spec send_message(WhatsApp.Client.t(), map(), keyword())"
    end

    test "GET on collection has correct spec", %{output_dir: output_dir} do
      source = read_service(output_dir, "groups/groups_service.ex")

      assert source =~
               "@spec get_active_groups(WhatsApp.Client.t(), keyword())"
    end

    test "GET with function arg has correct spec", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")

      assert source =~
               "@spec get_media_url(WhatsApp.Client.t(), String.t(), keyword())"
    end

    test "all specs include return type", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")

      assert source =~
               "{:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}"
    end
  end

  # ── 10. @doc annotations ───────────────────────────────────────────────

  describe "@doc annotations" do
    test "send_message has summary in doc", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ "Send Message."
    end

    test "send_message has description in doc", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ "Send a message to a WhatsApp user."
    end

    test "send_message has examples in doc", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ "## Examples"
      assert source =~ "Send Text Message"
      assert source =~ "Send Image Message"
    end

    test "get_media_url has parameter docs for media_id", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      assert source =~ "## Parameters"
      assert source =~ "`media_id`"
    end
  end

  # ── 11. HTTP method correctness ────────────────────────────────────────

  describe "HTTP method" do
    test "send_message uses :post", %{output_dir: output_dir} do
      source = read_service(output_dir, "messages/messages_service.ex")
      assert source =~ "Client.request("
      assert source =~ ":post"
    end

    test "upload_media uses :post", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/media_service.ex")
      assert source =~ "Client.request("
      assert source =~ ":post"
    end

    test "get_media_url uses :get", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      get_fn = extract_function(source, "get_media_url")
      assert get_fn =~ "Client.request("
      assert get_fn =~ ":get"
    end

    test "delete_media uses :delete", %{output_dir: output_dir} do
      source = read_service(output_dir, "media/root_service.ex")
      delete_fn = extract_function(source, "delete_media")
      assert delete_fn =~ "Client.request("
      assert delete_fn =~ ":delete"
    end

    test "get_active_groups uses :get", %{output_dir: output_dir} do
      source = read_service(output_dir, "groups/groups_service.ex")
      assert source =~ "Client.request("
      assert source =~ ":get"
    end
  end

  # ── 12. WhatsApp.Client.request call ───────────────────────────────────

  describe "Client.request call" do
    test "all generated functions call WhatsApp.Client.request", %{
      generated: generated,
      output_dir: output_dir
    } do
      for {path, _module} <- generated do
        source = File.read!(Path.join(output_dir, path))
        assert source =~ "WhatsApp.Client.request(", "#{path} missing Client.request call"
      end
    end
  end

  # ── 13. Formatted output ───────────────────────────────────────────────

  describe "formatted output" do
    test "generated files are valid formatted Elixir", %{
      generated: generated,
      output_dir: output_dir
    } do
      for {path, _module} <- generated do
        full = Path.join(output_dir, path)
        source = File.read!(full)

        # Code.format_string! will raise if the code is not valid Elixir
        formatted = Code.format_string!(source) |> IO.iodata_to_binary()
        # The source should already be formatted (trimmed trailing newline for comparison)
        assert String.trim(source) == String.trim(formatted),
               "#{path} is not properly formatted"
      end
    end
  end

  # ── Helpers ─────────────────────────────────────────────────────────────

  defp read_service(output_dir, relative) do
    Path.join([output_dir, "lib/whatsapp", relative])
    |> File.read!()
  end

  defp extract_function(source, function_name) do
    # Extract the function body from source by finding the def line to the matching end
    lines = String.split(source, "\n")

    start_idx =
      Enum.find_index(lines, fn line ->
        line =~ ~r/\s*def #{function_name}\(/
      end)

    if start_idx do
      # Find the matching end by counting def/end pairs
      rest = Enum.drop(lines, start_idx)
      {fn_lines, _} = take_until_end(rest, 0, [])
      Enum.join(fn_lines, "\n")
    else
      ""
    end
  end

  defp take_until_end([], _depth, acc), do: {Enum.reverse(acc), []}

  defp take_until_end([line | rest], depth, acc) do
    new_depth =
      cond do
        line =~ ~r/^\s*(def |defp |defmodule |case |cond |if |fn |do$|do:)/ ->
          depth + 1

        String.trim(line) == "end" ->
          depth - 1

        line =~ ~r/\bdo$/ ->
          depth + 1

        true ->
          depth
      end

    if new_depth <= 0 and depth > 0 do
      {Enum.reverse([line | acc]), rest}
    else
      take_until_end(rest, new_depth, [line | acc])
    end
  end
end
