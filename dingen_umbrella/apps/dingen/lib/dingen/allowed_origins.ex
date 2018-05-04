defmodule Dingen.AllowedOrigins do
  use GenServer

  def start_link(allowed_origins) do
    initial_state = MapSet.new(allowed_origins)
    gen_server_opts = [name: __MODULE__]
    GenServer.start_link(__MODULE__, initial_state, gen_server_opts)
  end

  def init(state) do
    {:ok, state}
  end

  # Client api
  def list() do
    GenServer.call(__MODULE__, :list)
  end

  def insert(origin) do
    GenServer.call(__MODULE__, {:insert, origin})
  end

  def delete(origin) do
    GenServer.call(__MODULE__, {:delete, origin})
  end

  # Server api
  def handle_call(:list, _from, state) do
    {:reply, MapSet.to_list(state), state}
  end

  def handle_call({:insert, origin}, _from, state) do
    state = MapSet.put(state, origin)
    {:reply, MapSet.to_list(state), state}
  end

  def handle_call({:delete, origin}, _from, state) do
    state = MapSet.delete(state, origin)
    {:reply, MapSet.to_list(state), state}
  end
end
