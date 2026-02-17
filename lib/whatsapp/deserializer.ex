defmodule WhatsApp.Deserializer do
  @moduledoc """
  Format-aware deserializer for WhatsApp API responses.

  Converts JSON-decoded maps (with string keys) into typed Elixir structs.
  Each service method knows its expected response type and passes it here for
  structured deserialization.

  ## Features

  - **String-key to atom-key mapping** -- maps `"field_name"` keys to struct
    atom fields automatically.
  - **Format-aware casting** -- when the target module exposes a
    `__field_meta__/0` function, ISO 8601 date-time, date, and time strings
    are parsed into their respective Elixir structs (`DateTime`, `Date`,
    `Time`).
  - **Nested resource deserialization** -- fields typed as `{:ref, Module}` or
    `{:array, {:ref, Module}}` are recursively deserialized.
  - **Discriminator-based polymorphism** -- `deserialize_polymorphic/3`
    dispatches to the correct module based on a discriminator field value.

  ## Usage

      # Simple deserialization
      data = %{"id" => "123", "name" => "Test"}
      struct = WhatsApp.Deserializer.deserialize(data, MyApp.Resource)

      # List deserialization
      items = WhatsApp.Deserializer.deserialize_list(list_of_maps, MyApp.Resource)

      # Polymorphic dispatch
      mapping = %{"text" => TextMessage, "image" => ImageMessage}
      result = WhatsApp.Deserializer.deserialize_polymorphic(data, "type", mapping)
  """

  @doc """
  Deserialize a string-keyed map into a struct of the given module.

  Field values are cast according to the module's `__field_meta__/0` metadata
  when available. Modules without `__field_meta__/0` get basic string-key to
  atom-key mapping with no format casting.

  Unknown keys in the data map are silently ignored. Missing keys default to
  `nil` (or the struct's default value).
  """
  @spec deserialize(map(), module()) :: struct()
  def deserialize(data, module) when is_map(data) and is_atom(module) do
    field_keys =
      module.__struct__()
      |> Map.keys()
      |> List.delete(:__struct__)

    field_meta = fetch_field_meta(module)

    attrs =
      Enum.reduce(field_keys, [], fn field, acc ->
        string_key = Atom.to_string(field)

        case Map.fetch(data, string_key) do
          {:ok, value} ->
            meta = Map.get(field_meta, field)
            cast_value = cast_field(value, meta)
            [{field, cast_value} | acc]

          :error ->
            acc
        end
      end)

    struct(module, attrs)
  end

  @doc """
  Deserialize a list of string-keyed maps into a list of structs.
  """
  @spec deserialize_list([map()], module()) :: [struct()]
  def deserialize_list(data, module) when is_list(data) and is_atom(module) do
    Enum.map(data, &deserialize(&1, module))
  end

  @doc """
  Deserialize a map using discriminator-based polymorphism.

  Looks up the value of `discriminator_field` in the data map and resolves it
  against the provided `mapping` to determine which module to deserialize into.

  Returns `{:error, :unknown_type}` if the discriminator value is not found in
  the mapping or the discriminator field is missing from the data.

  ## Parameters

  - `data` -- the string-keyed map to deserialize
  - `discriminator_field` -- the string key used as the discriminator
    (e.g., `"type"`)
  - `mapping` -- a map from discriminator values to module names
    (e.g., `%{"text" => TextMessage, "image" => ImageMessage}`)
  """
  @spec deserialize_polymorphic(map(), String.t(), %{String.t() => module()}) ::
          struct() | {:error, :unknown_type}
  def deserialize_polymorphic(data, discriminator_field, mapping)
      when is_map(data) and is_binary(discriminator_field) and is_map(mapping) do
    with {:ok, type_value} <- Map.fetch(data, discriminator_field),
         {:ok, module} <- Map.fetch(mapping, type_value) do
      deserialize(data, module)
    else
      :error -> {:error, :unknown_type}
    end
  end

  # ---------------------------------------------------------------------------
  # Private helpers
  # ---------------------------------------------------------------------------

  defp fetch_field_meta(module) do
    if function_exported?(module, :__field_meta__, 0) do
      module.__field_meta__()
    else
      %{}
    end
  end

  defp cast_field(nil, _meta), do: nil

  defp cast_field(value, %{format: :date_time}) when is_binary(value) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, _offset} -> datetime
      {:error, _reason} -> value
    end
  end

  defp cast_field(value, %{format: :date}) when is_binary(value) do
    case Date.from_iso8601(value) do
      {:ok, date} -> date
      {:error, _reason} -> value
    end
  end

  defp cast_field(value, %{format: :time}) when is_binary(value) do
    case Time.from_iso8601(value) do
      {:ok, time} -> time
      {:error, _reason} -> value
    end
  end

  defp cast_field(value, %{type: {:ref, module}}) when is_map(value) do
    deserialize(value, module)
  end

  defp cast_field(value, %{type: {:array, {:ref, module}}}) when is_list(value) do
    Enum.map(value, &deserialize(&1, module))
  end

  defp cast_field(value, _meta), do: value
end
