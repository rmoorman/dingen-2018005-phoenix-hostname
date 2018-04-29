defmodule DingenWeb.DynamicHost.Storage do
  alias DingenWeb.DynamicHost.Storage.Cache

  def contains?(host) do
    GenServer.call(Cache, {:contains, host})
  end
end
