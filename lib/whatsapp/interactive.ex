defmodule WhatsApp.Interactive do
  @moduledoc """
  Builders for WhatsApp interactive messages.

  Provides a functional pipeline API for constructing interactive message
  payloads -- buttons, lists, CTAs, flows, and products.

  ## Examples

      # Quick reply buttons
      payload =
        WhatsApp.Interactive.buttons("Choose an option:")
        |> WhatsApp.Interactive.button("yes", "Yes, proceed")
        |> WhatsApp.Interactive.button("no", "No, cancel")
        |> WhatsApp.Interactive.build()

      # List message
      payload =
        WhatsApp.Interactive.list("Main Menu", "View options")
        |> WhatsApp.Interactive.section("Products", [
          WhatsApp.Interactive.row("prod_1", "Widget", "Our best widget"),
          WhatsApp.Interactive.row("prod_2", "Gadget", "Our best gadget")
        ])
        |> WhatsApp.Interactive.build()
  """

  @type builder :: map()

  # ---------- Button Messages ----------

  @doc """
  Start building a button message.

  ## Options

    * `:header` - Optional header text
    * `:footer` - Optional footer text
  """
  @spec buttons(String.t(), keyword()) :: builder()
  def buttons(body_text, opts \\ []) do
    %{
      "type" => "button",
      "body" => %{"text" => body_text},
      "action" => %{"buttons" => []}
    }
    |> maybe_add_header(Keyword.get(opts, :header))
    |> maybe_add_footer(Keyword.get(opts, :footer))
  end

  @doc """
  Add a reply button to a button message.

  Title must be at most 20 bytes. A maximum of 3 buttons per message is
  supported by the WhatsApp API.
  """
  @spec button(builder(), String.t(), String.t()) :: builder()
  def button(builder, id, title) when byte_size(title) <= 20 do
    btn = %{"type" => "reply", "reply" => %{"id" => id, "title" => title}}
    update_in(builder, ["action", "buttons"], &(&1 ++ [btn]))
  end

  # ---------- List Messages ----------

  @doc """
  Start building a list message.

  ## Options

    * `:header` - Optional header text
    * `:footer` - Optional footer text
  """
  @spec list(String.t(), String.t(), keyword()) :: builder()
  def list(body_text, button_text, opts \\ []) do
    %{
      "type" => "list",
      "body" => %{"text" => body_text},
      "action" => %{"button" => button_text, "sections" => []}
    }
    |> maybe_add_header(Keyword.get(opts, :header))
    |> maybe_add_footer(Keyword.get(opts, :footer))
  end

  @doc """
  Add a section with rows to a list message.
  """
  @spec section(builder(), String.t(), [map()]) :: builder()
  def section(builder, title, rows) do
    sec = %{"title" => title, "rows" => rows}
    update_in(builder, ["action", "sections"], &(&1 ++ [sec]))
  end

  @doc """
  Create a row for a list section.

  Description is optional and only included when provided.
  """
  @spec row(String.t(), String.t(), String.t() | nil) :: map()
  def row(id, title, description \\ nil) do
    base = %{"id" => id, "title" => title}

    if description do
      Map.put(base, "description", description)
    else
      base
    end
  end

  # ---------- CTA URL Messages ----------

  @doc """
  Build a CTA URL message.

  ## Options

    * `:header` - Optional header text
    * `:footer` - Optional footer text
  """
  @spec cta_url(String.t(), String.t(), String.t(), keyword()) :: builder()
  def cta_url(body_text, display_text, url, opts \\ []) do
    %{
      "type" => "cta_url",
      "body" => %{"text" => body_text},
      "action" => %{
        "name" => "cta_url",
        "parameters" => %{
          "display_text" => display_text,
          "url" => url
        }
      }
    }
    |> maybe_add_header(Keyword.get(opts, :header))
    |> maybe_add_footer(Keyword.get(opts, :footer))
  end

  # ---------- Flow Messages ----------

  @doc """
  Build a Flow trigger message.

  ## Options

    * `:header` - Optional header text
    * `:footer` - Optional footer text
    * `:flow_action` - Flow action, defaults to `"navigate"`
    * `:flow_action_payload` - Optional map payload added to parameters
  """
  @spec flow(String.t(), String.t(), String.t(), keyword()) :: builder()
  def flow(body_text, flow_id, flow_cta, opts \\ []) do
    parameters =
      %{
        "flow_id" => flow_id,
        "flow_cta" => flow_cta,
        "flow_action" => Keyword.get(opts, :flow_action, "navigate")
      }
      |> maybe_add_flow_payload(Keyword.get(opts, :flow_action_payload))

    %{
      "type" => "flow",
      "body" => %{"text" => body_text},
      "action" => %{
        "name" => "flow",
        "parameters" => parameters
      }
    }
    |> maybe_add_header(Keyword.get(opts, :header))
    |> maybe_add_footer(Keyword.get(opts, :footer))
  end

  # ---------- Location Request ----------

  @doc """
  Build a location request message.
  """
  @spec location_request(String.t()) :: builder()
  def location_request(body_text) do
    %{
      "type" => "location_request_message",
      "body" => %{"text" => body_text},
      "action" => %{"name" => "send_location"}
    }
  end

  # ---------- Product Messages ----------

  @doc """
  Build a single product message.

  ## Options

    * `:body` - Optional body text
    * `:footer` - Optional footer text
  """
  @spec product(String.t(), String.t(), keyword()) :: builder()
  def product(catalog_id, product_retailer_id, opts \\ []) do
    %{
      "type" => "product",
      "action" => %{
        "catalog_id" => catalog_id,
        "product_retailer_id" => product_retailer_id
      }
    }
    |> maybe_add_body(Keyword.get(opts, :body))
    |> maybe_add_footer(Keyword.get(opts, :footer))
  end

  @doc """
  Build a multi-product list message.

  ## Options

    * `:header` - Optional header text
    * `:footer` - Optional footer text
  """
  @spec product_list(String.t(), String.t(), keyword()) :: builder()
  def product_list(body_text, catalog_id, opts \\ []) do
    %{
      "type" => "product_list",
      "body" => %{"text" => body_text},
      "action" => %{
        "catalog_id" => catalog_id,
        "sections" => []
      }
    }
    |> maybe_add_header(Keyword.get(opts, :header))
    |> maybe_add_footer(Keyword.get(opts, :footer))
  end

  @doc """
  Add a product section to a product list message.
  """
  @spec product_section(builder(), String.t(), [String.t()]) :: builder()
  def product_section(builder, title, product_retailer_ids) do
    products = Enum.map(product_retailer_ids, &%{"product_retailer_id" => &1})
    sec = %{"title" => title, "product_items" => products}
    update_in(builder, ["action", "sections"], &(&1 ++ [sec]))
  end

  # ---------- Build ----------

  @doc """
  Finalize the builder and return the payload map.

  This is an identity function -- the builder map is the payload.
  """
  @spec build(builder()) :: map()
  def build(builder), do: builder

  # ---------- Private helpers ----------

  defp maybe_add_header(msg, nil), do: msg

  defp maybe_add_header(msg, text),
    do: Map.put(msg, "header", %{"type" => "text", "text" => text})

  defp maybe_add_footer(msg, nil), do: msg
  defp maybe_add_footer(msg, text), do: Map.put(msg, "footer", %{"text" => text})

  defp maybe_add_body(msg, nil), do: msg
  defp maybe_add_body(msg, text), do: Map.put(msg, "body", %{"text" => text})

  defp maybe_add_flow_payload(params, nil), do: params

  defp maybe_add_flow_payload(params, payload),
    do: Map.put(params, "flow_action_payload", payload)
end
