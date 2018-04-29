defmodule Dingen.AllowedHosts do
  use GenServer

  def start_link(allowed_hosts) do
    initial_state = MapSet.new(allowed_hosts)
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

  def insert(host) do
    GenServer.call(__MODULE__, {:insert, host})
  end

  def delete(host) do
    GenServer.call(__MODULE__, {:delete, host})
  end

  # Server api
  def handle_call(:list, _from, state) do
    {:reply, MapSet.to_list(state), state}
  end

  def handle_call({:insert, host}, _from, state) do
    state = MapSet.put(state, host)
    {:reply, MapSet.to_list(state), state}
  end

  def handle_call({:delete, host}, _from, state) do
    state = MapSet.delete(state, host)
    {:reply, MapSet.to_list(state), state}
  end
end
