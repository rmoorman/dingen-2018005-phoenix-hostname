defmodule DingenWeb.DynamicHost.Storage do
  use GenServer

  require Logger

  defmodule State do
    defstruct [
      refresh_after_seconds: 5,
    ]
  end

  @ets_table __MODULE__

  def start_link(_arg) do
    initial_state = %State{}
    gen_server_opts = [name: __MODULE__]
    GenServer.start_link(__MODULE__, initial_state, gen_server_opts)
  end

  def init(state) do
    :ets.new(@ets_table, [
      :named_table,
      :set,
      :protected,
      read_concurrency: true,
    ])
    send(self(), :refresh)
    {:ok, state}
  end

  def contains?(host) do
    case :ets.lookup(@ets_table, host) do
      [{_host}] -> true
      _ -> false
    end
  end

  def handle_info(:refresh, state) do
    new_hosts = Dingen.list_allowed_hosts()

    # get the list of currently cached hosts
    current_hosts =
      :ets.tab2list(@ets_table)
      |> Enum.map(fn {host} -> host end)

    # insert what has to be inserted
    insert_hosts = new_hosts -- current_hosts
    if length(insert_hosts) > 0 do
      Logger.info("Allowing hosts #{inspect(insert_hosts)}")
      :ets.insert(@ets_table, Enum.map(insert_hosts, fn host -> {host} end))
    end

    # delete what has to be deleted
    delete_hosts = current_hosts -- new_hosts
    if length(delete_hosts) > 0 do
      Logger.info("Disallowing hosts #{inspect(delete_hosts)}")
      Enum.map(delete_hosts, fn host -> :ets.delete(@ets_table, host) end)
    end

    Process.send_after(self(), :refresh, :timer.seconds(state.refresh_after_seconds))
    {:noreply, state}
  end
end
