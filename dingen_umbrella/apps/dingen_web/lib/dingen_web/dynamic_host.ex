defmodule DingenWeb.DynamicHost do
  @moduledoc """
  Module for dynamically checking if a given hostname is allowed.
  """

  alias DingenWeb.DynamicHost.Storage

  @doc """
  Check if a given hostname is allowed for a given endpoint.
  """
  def host_allowed?(host) do
    Storage.contains?(host)
  end
end
