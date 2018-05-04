defmodule DingenWeb.DynamicOrigin do
  @moduledoc """
  Module for dynamically checking if a given origin is allowed.
  """

  alias DingenWeb.DynamicOrigin.Storage

  @doc """
  Check if a given origin url is allowed.
  """
  def origin_allowed?(origin) do
    Storage.contains?(origin)
  end
end
