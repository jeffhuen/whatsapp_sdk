defmodule WhatsApp do
  @moduledoc "Elixir SDK for the WhatsApp Business Platform Cloud API."

  @version Mix.Project.config()[:version]

  @doc "Build a client from application config."
  @spec client() :: WhatsApp.Client.t()
  def client, do: WhatsApp.Client.new()

  @doc "Build a client from an explicit access token and options."
  @spec client(String.t(), keyword()) :: WhatsApp.Client.t()
  def client(access_token, opts \\ []), do: WhatsApp.Client.new(access_token, opts)

  @doc "Return the SDK version string."
  @spec version() :: String.t()
  def version, do: @version
end
