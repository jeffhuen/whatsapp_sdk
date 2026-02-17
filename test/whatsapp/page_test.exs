defmodule WhatsApp.PageTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Page

  # A simple deserialize function for testing: wraps each map in a tagged tuple.
  defp test_deserialize(%{"id" => id, "name" => name}), do: %{id: id, name: name}
  defp test_deserialize(item), do: item

  @sample_response %{
    "data" => [
      %{"id" => "1", "name" => "Template A"},
      %{"id" => "2", "name" => "Template B"}
    ],
    "paging" => %{
      "cursors" => %{
        "before" => "QVFIUl_before",
        "after" => "QVFIUk_after"
      },
      "next" => "https://graph.facebook.com/v23.0/12345/message_templates?after=QVFIUk_after",
      "previous" =>
        "https://graph.facebook.com/v23.0/12345/message_templates?before=QVFIUl_before"
    }
  }

  describe "from_response/2" do
    test "parses data items with deserialize function" do
      page = Page.from_response(@sample_response, &test_deserialize/1)

      assert page.data == [
               %{id: "1", name: "Template A"},
               %{id: "2", name: "Template B"}
             ]
    end

    test "extracts cursor values" do
      page = Page.from_response(@sample_response, &test_deserialize/1)

      assert page.cursors == %{before: "QVFIUl_before", after: "QVFIUk_after"}
    end

    test "extracts next and previous URLs" do
      page = Page.from_response(@sample_response, &test_deserialize/1)

      assert page.next_url ==
               "https://graph.facebook.com/v23.0/12345/message_templates?after=QVFIUk_after"

      assert page.previous_url ==
               "https://graph.facebook.com/v23.0/12345/message_templates?before=QVFIUl_before"
    end

    test "handles missing paging key (empty/last page)" do
      response = %{"data" => [%{"id" => "1", "name" => "Only"}]}
      page = Page.from_response(response, &test_deserialize/1)

      assert page.data == [%{id: "1", name: "Only"}]
      assert page.cursors == %{before: nil, after: nil}
      assert page.next_url == nil
      assert page.previous_url == nil
    end

    test "handles nil paging value" do
      response = %{"data" => [%{"id" => "1", "name" => "Only"}], "paging" => nil}
      page = Page.from_response(response, &test_deserialize/1)

      assert page.data == [%{id: "1", name: "Only"}]
      assert page.cursors == %{before: nil, after: nil}
      assert page.next_url == nil
      assert page.previous_url == nil
    end

    test "handles paging with missing cursors key" do
      response = %{
        "data" => [],
        "paging" => %{
          "next" => "https://example.com/next"
        }
      }

      page = Page.from_response(response, nil)

      assert page.cursors == %{before: nil, after: nil}
      assert page.next_url == "https://example.com/next"
    end

    test "with nil deserialize_fn passes data through as raw maps" do
      page = Page.from_response(@sample_response, nil)

      assert page.data == [
               %{"id" => "1", "name" => "Template A"},
               %{"id" => "2", "name" => "Template B"}
             ]
    end

    test "handles missing data key" do
      response = %{"paging" => %{"cursors" => %{"after" => "abc"}}}
      page = Page.from_response(response, nil)

      assert page.data == []
    end

    test "handles completely empty response" do
      page = Page.from_response(%{}, nil)

      assert page.data == []
      assert page.cursors == %{before: nil, after: nil}
      assert page.next_url == nil
      assert page.previous_url == nil
    end
  end

  describe "has_next?/1" do
    test "returns true when next_url is present" do
      page = Page.from_response(@sample_response, nil)
      assert Page.has_next?(page) == true
    end

    test "returns false when next_url is nil" do
      page = %Page{next_url: nil}
      assert Page.has_next?(page) == false
    end
  end

  describe "has_previous?/1" do
    test "returns true when previous_url is present" do
      page = Page.from_response(@sample_response, nil)
      assert Page.has_previous?(page) == true
    end

    test "returns false when previous_url is nil" do
      page = %Page{previous_url: nil}
      assert Page.has_previous?(page) == false
    end
  end

  describe "stream/3" do
    test "yields all items from a single page (no next)" do
      page = %Page{
        data: [%{id: 1}, %{id: 2}, %{id: 3}],
        next_url: nil
      }

      items = page |> Page.stream(nil, []) |> Enum.to_list()
      assert items == [%{id: 1}, %{id: 2}, %{id: 3}]
    end

    test "auto-fetches next page and yields all items" do
      page2_response = %{
        "data" => [%{"id" => "3", "name" => "Template C"}, %{"id" => "4", "name" => "Template D"}],
        "paging" => %{
          "cursors" => %{"before" => "b2", "after" => "a2"}
        }
      }

      # fetch_fn simulates Client.request_url — returns {:ok, response_body}
      fetch_fn = fn _client, url ->
        case url do
          "https://example.com/page2" ->
            {:ok, page2_response}

          _ ->
            {:error, :not_found}
        end
      end

      page1 = %Page{
        data: [%{id: "1", name: "Template A"}, %{id: "2", name: "Template B"}],
        next_url: "https://example.com/page2"
      }

      items =
        page1
        |> Page.stream(nil, fetch_fn: fetch_fn, deserialize_fn: &test_deserialize/1)
        |> Enum.to_list()

      # Page 1 items are already deserialized (stored in Page struct as-is).
      # Page 2 items are deserialized by deserialize_fn during fetch.
      assert items == [
               %{id: "1", name: "Template A"},
               %{id: "2", name: "Template B"},
               %{id: "3", name: "Template C"},
               %{id: "4", name: "Template D"}
             ]
    end

    test "auto-fetches multiple pages and yields all items" do
      page2_response = %{
        "data" => [%{"id" => "3"}],
        "paging" => %{
          "cursors" => %{"before" => "b2", "after" => "a2"},
          "next" => "https://example.com/page3"
        }
      }

      page3_response = %{
        "data" => [%{"id" => "4"}, %{"id" => "5"}],
        "paging" => %{
          "cursors" => %{"before" => "b3", "after" => "a3"}
        }
      }

      fetch_fn = fn _client, url ->
        case url do
          "https://example.com/page2" -> {:ok, page2_response}
          "https://example.com/page3" -> {:ok, page3_response}
          _ -> {:error, :not_found}
        end
      end

      page1 = %Page{
        data: [%{"id" => "1"}, %{"id" => "2"}],
        next_url: "https://example.com/page2"
      }

      items =
        page1
        |> Page.stream(nil, fetch_fn: fetch_fn)
        |> Enum.to_list()

      assert items == [
               %{"id" => "1"},
               %{"id" => "2"},
               %{"id" => "3"},
               %{"id" => "4"},
               %{"id" => "5"}
             ]
    end

    test "stops when no more pages (next_url is nil)" do
      page = %Page{
        data: [%{id: 1}],
        next_url: nil
      }

      items = page |> Page.stream(nil, []) |> Enum.to_list()
      assert items == [%{id: 1}]
    end

    test "stops on fetch error without crashing" do
      fetch_fn = fn _client, _url ->
        {:error, %WhatsApp.Error{message: "connection refused"}}
      end

      page = %Page{
        data: [%{id: 1}, %{id: 2}],
        next_url: "https://example.com/page2"
      }

      items =
        page
        |> Page.stream(nil, fetch_fn: fetch_fn)
        |> Enum.to_list()

      # Should yield page 1 items and then stop (not crash)
      assert items == [%{id: 1}, %{id: 2}]
    end

    test "works without deserialize function (raw maps)" do
      page2_response = %{
        "data" => [%{"id" => "3", "name" => "C"}],
        "paging" => %{}
      }

      fetch_fn = fn _client, _url -> {:ok, page2_response} end

      page1 = %Page{
        data: [%{"id" => "1", "name" => "A"}, %{"id" => "2", "name" => "B"}],
        next_url: "https://example.com/page2"
      }

      items =
        page1
        |> Page.stream(nil, fetch_fn: fetch_fn)
        |> Enum.to_list()

      assert items == [
               %{"id" => "1", "name" => "A"},
               %{"id" => "2", "name" => "B"},
               %{"id" => "3", "name" => "C"}
             ]
    end

    test "stream is lazy — only fetches pages as needed" do
      # Use an Agent to track how many times fetch is called
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      page2_response = %{
        "data" => [%{"id" => "3"}],
        "paging" => %{
          "cursors" => %{},
          "next" => "https://example.com/page3"
        }
      }

      page3_response = %{
        "data" => [%{"id" => "4"}],
        "paging" => %{}
      }

      fetch_fn = fn _client, url ->
        Agent.update(agent, &(&1 + 1))

        case url do
          "https://example.com/page2" -> {:ok, page2_response}
          "https://example.com/page3" -> {:ok, page3_response}
        end
      end

      page1 = %Page{
        data: [%{"id" => "1"}, %{"id" => "2"}],
        next_url: "https://example.com/page2"
      }

      # Take only 3 items (page1 has 2, so only one fetch for page2)
      items =
        page1
        |> Page.stream(nil, fetch_fn: fetch_fn)
        |> Enum.take(3)

      assert items == [%{"id" => "1"}, %{"id" => "2"}, %{"id" => "3"}]

      # Only one additional page should have been fetched
      assert Agent.get(agent, & &1) == 1

      Agent.stop(agent)
    end

    test "handles empty first page with no next" do
      page = %Page{data: [], next_url: nil}

      items = page |> Page.stream(nil, []) |> Enum.to_list()
      assert items == []
    end
  end
end
