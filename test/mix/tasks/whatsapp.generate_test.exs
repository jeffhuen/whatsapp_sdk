defmodule Mix.Tasks.Whatsapp.GenerateTest do
  use ExUnit.Case, async: true

  describe "module structure" do
    test "module exists" do
      assert Code.ensure_loaded?(Mix.Tasks.Whatsapp.Generate)
    end

    test "has run/1 function" do
      Code.ensure_loaded!(Mix.Tasks.Whatsapp.Generate)
      assert function_exported?(Mix.Tasks.Whatsapp.Generate, :run, 1)
    end

    test "is a Mix task with @shortdoc" do
      assert Mix.Task.shortdoc(Mix.Tasks.Whatsapp.Generate) != nil
    end
  end
end
