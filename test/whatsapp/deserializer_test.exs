defmodule WhatsApp.DeserializerTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Deserializer

  # --------------------------------------------------------------------------
  # Test struct modules
  # --------------------------------------------------------------------------

  # Test struct without __field_meta__
  defmodule SimpleResource do
    defstruct [:name, :age, :active]
  end

  # Test struct with date/time format metadata
  defmodule TimestampedResource do
    defstruct [:id, :created_at, :updated_at, :expires_on, :starts_at_time]

    def __field_meta__ do
      %{
        created_at: %{format: :date_time},
        updated_at: %{format: :date_time},
        expires_on: %{format: :date},
        starts_at_time: %{format: :time}
      }
    end
  end

  # Test struct for nested resources (ref)
  defmodule NestedParent do
    defstruct [:id, :child]

    def __field_meta__ do
      %{
        child: %{type: {:ref, WhatsApp.DeserializerTest.SimpleResource}}
      }
    end
  end

  # Test struct for list of refs
  defmodule ListParent do
    defstruct [:id, :items]

    def __field_meta__ do
      %{
        items: %{type: {:array, {:ref, WhatsApp.DeserializerTest.SimpleResource}}}
      }
    end
  end

  # Polymorphic types for discriminator tests
  defmodule Dog do
    defstruct [:name, :breed]
  end

  defmodule Cat do
    defstruct [:name, :color]
  end

  # --------------------------------------------------------------------------
  # deserialize/2 — basic (no __field_meta__)
  # --------------------------------------------------------------------------

  describe "deserialize/2 without __field_meta__" do
    test "converts string-keyed map to struct" do
      data = %{"name" => "Alice", "age" => 30, "active" => true}

      result = Deserializer.deserialize(data, SimpleResource)

      assert %SimpleResource{} = result
      assert result.name == "Alice"
      assert result.age == 30
      assert result.active == true
    end

    test "ignores unknown keys in the data" do
      data = %{"name" => "Alice", "unknown_field" => "ignored"}

      result = Deserializer.deserialize(data, SimpleResource)

      assert %SimpleResource{} = result
      assert result.name == "Alice"
      assert result.age == nil
    end

    test "missing keys result in nil defaults" do
      data = %{"name" => "Bob"}

      result = Deserializer.deserialize(data, SimpleResource)

      assert %SimpleResource{} = result
      assert result.name == "Bob"
      assert result.age == nil
      assert result.active == nil
    end

    test "handles empty data map" do
      result = Deserializer.deserialize(%{}, SimpleResource)

      assert %SimpleResource{} = result
      assert result.name == nil
      assert result.age == nil
      assert result.active == nil
    end
  end

  # --------------------------------------------------------------------------
  # deserialize/2 — date-time format casting
  # --------------------------------------------------------------------------

  describe "deserialize/2 with date-time format" do
    test "parses valid ISO 8601 datetime string to DateTime" do
      data = %{
        "id" => "123",
        "created_at" => "2024-01-15T10:30:00Z",
        "updated_at" => "2024-06-20T14:45:30+00:00"
      }

      result = Deserializer.deserialize(data, TimestampedResource)

      assert %TimestampedResource{} = result
      assert result.id == "123"
      assert %DateTime{} = result.created_at
      assert result.created_at.year == 2024
      assert result.created_at.month == 1
      assert result.created_at.day == 15
      assert result.created_at.hour == 10
      assert result.created_at.minute == 30
      assert %DateTime{} = result.updated_at
      assert result.updated_at.year == 2024
    end

    test "returns invalid datetime string as-is (no crash)" do
      data = %{"id" => "123", "created_at" => "not-a-date"}

      result = Deserializer.deserialize(data, TimestampedResource)

      assert result.created_at == "not-a-date"
    end

    test "nil datetime values pass through as nil" do
      data = %{"id" => "123", "created_at" => nil}

      result = Deserializer.deserialize(data, TimestampedResource)

      assert result.created_at == nil
    end
  end

  # --------------------------------------------------------------------------
  # deserialize/2 — date format casting
  # --------------------------------------------------------------------------

  describe "deserialize/2 with date format" do
    test "parses valid ISO 8601 date string to Date" do
      data = %{"id" => "123", "expires_on" => "2024-12-31"}

      result = Deserializer.deserialize(data, TimestampedResource)

      assert %Date{} = result.expires_on
      assert result.expires_on == ~D[2024-12-31]
    end

    test "returns invalid date string as-is" do
      data = %{"id" => "123", "expires_on" => "invalid-date"}

      result = Deserializer.deserialize(data, TimestampedResource)

      assert result.expires_on == "invalid-date"
    end

    test "nil date values pass through as nil" do
      data = %{"id" => "123", "expires_on" => nil}

      result = Deserializer.deserialize(data, TimestampedResource)

      assert result.expires_on == nil
    end
  end

  # --------------------------------------------------------------------------
  # deserialize/2 — time format casting
  # --------------------------------------------------------------------------

  describe "deserialize/2 with time format" do
    test "parses valid ISO 8601 time string to Time" do
      data = %{"id" => "123", "starts_at_time" => "14:30:00"}

      result = Deserializer.deserialize(data, TimestampedResource)

      assert %Time{} = result.starts_at_time
      assert result.starts_at_time == ~T[14:30:00]
    end

    test "returns invalid time string as-is" do
      data = %{"id" => "123", "starts_at_time" => "not-a-time"}

      result = Deserializer.deserialize(data, TimestampedResource)

      assert result.starts_at_time == "not-a-time"
    end

    test "nil time values pass through as nil" do
      data = %{"id" => "123", "starts_at_time" => nil}

      result = Deserializer.deserialize(data, TimestampedResource)

      assert result.starts_at_time == nil
    end
  end

  # --------------------------------------------------------------------------
  # deserialize/2 — nested ref
  # --------------------------------------------------------------------------

  describe "deserialize/2 with nested ref" do
    test "deserializes nested map into child struct" do
      data = %{
        "id" => "parent-1",
        "child" => %{"name" => "Child", "age" => 5, "active" => true}
      }

      result = Deserializer.deserialize(data, NestedParent)

      assert %NestedParent{} = result
      assert result.id == "parent-1"
      assert %SimpleResource{} = result.child
      assert result.child.name == "Child"
      assert result.child.age == 5
      assert result.child.active == true
    end

    test "nil nested ref passes through as nil" do
      data = %{"id" => "parent-1", "child" => nil}

      result = Deserializer.deserialize(data, NestedParent)

      assert result.child == nil
    end
  end

  # --------------------------------------------------------------------------
  # deserialize/2 — list of refs
  # --------------------------------------------------------------------------

  describe "deserialize/2 with list of refs" do
    test "deserializes list of maps into list of structs" do
      data = %{
        "id" => "list-parent-1",
        "items" => [
          %{"name" => "Item1", "age" => 1, "active" => true},
          %{"name" => "Item2", "age" => 2, "active" => false}
        ]
      }

      result = Deserializer.deserialize(data, ListParent)

      assert %ListParent{} = result
      assert result.id == "list-parent-1"
      assert length(result.items) == 2

      [item1, item2] = result.items
      assert %SimpleResource{} = item1
      assert item1.name == "Item1"
      assert item1.age == 1
      assert %SimpleResource{} = item2
      assert item2.name == "Item2"
      assert item2.active == false
    end

    test "nil list passes through as nil" do
      data = %{"id" => "list-parent-1", "items" => nil}

      result = Deserializer.deserialize(data, ListParent)

      assert result.items == nil
    end

    test "empty list is preserved" do
      data = %{"id" => "list-parent-1", "items" => []}

      result = Deserializer.deserialize(data, ListParent)

      assert result.items == []
    end
  end

  # --------------------------------------------------------------------------
  # deserialize_list/2
  # --------------------------------------------------------------------------

  describe "deserialize_list/2" do
    test "deserializes a list of maps into a list of structs" do
      data = [
        %{"name" => "Alice", "age" => 30, "active" => true},
        %{"name" => "Bob", "age" => 25, "active" => false}
      ]

      result = Deserializer.deserialize_list(data, SimpleResource)

      assert length(result) == 2
      [alice, bob] = result
      assert %SimpleResource{} = alice
      assert alice.name == "Alice"
      assert %SimpleResource{} = bob
      assert bob.name == "Bob"
    end

    test "handles empty list" do
      result = Deserializer.deserialize_list([], SimpleResource)

      assert result == []
    end
  end

  # --------------------------------------------------------------------------
  # deserialize_polymorphic/3
  # --------------------------------------------------------------------------

  describe "deserialize_polymorphic/3" do
    test "dispatches to correct module based on discriminator field" do
      mapping = %{
        "dog" => Dog,
        "cat" => Cat
      }

      data = %{"type" => "dog", "name" => "Rex", "breed" => "Labrador"}

      result = Deserializer.deserialize_polymorphic(data, "type", mapping)

      assert %Dog{} = result
      assert result.name == "Rex"
      assert result.breed == "Labrador"
    end

    test "dispatches to alternate module based on discriminator value" do
      mapping = %{
        "dog" => Dog,
        "cat" => Cat
      }

      data = %{"type" => "cat", "name" => "Whiskers", "color" => "orange"}

      result = Deserializer.deserialize_polymorphic(data, "type", mapping)

      assert %Cat{} = result
      assert result.name == "Whiskers"
      assert result.color == "orange"
    end

    test "returns {:error, :unknown_type} for unknown discriminator value" do
      mapping = %{
        "dog" => Dog,
        "cat" => Cat
      }

      data = %{"type" => "fish", "name" => "Nemo"}

      result = Deserializer.deserialize_polymorphic(data, "type", mapping)

      assert result == {:error, :unknown_type}
    end

    test "returns {:error, :unknown_type} when discriminator field is missing" do
      mapping = %{
        "dog" => Dog,
        "cat" => Cat
      }

      data = %{"name" => "Ghost"}

      result = Deserializer.deserialize_polymorphic(data, "type", mapping)

      assert result == {:error, :unknown_type}
    end
  end
end
