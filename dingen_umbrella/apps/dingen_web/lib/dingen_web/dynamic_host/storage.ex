defmodule DingenWeb.DynamicHost.Storage do
  alias DingenWeb.DynamicHost.Storage.Cache

  defdelegate contains?(host), to: Cache
end
