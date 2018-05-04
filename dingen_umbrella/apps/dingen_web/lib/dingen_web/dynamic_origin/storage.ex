defmodule DingenWeb.DynamicOrigin.Storage do
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

  def contains?(origin) when is_binary(origin) do
    origin_uri = URI.parse(origin)
    cleaned_origin_uri =
      %URI{scheme: origin_uri.scheme, host: origin_uri.host, port: origin_uri.port}
      |> URI.to_string
      |> URI.parse

    contains?(cleaned_origin_uri)
  end
  def contains?(%URI{} = origin_uri) do
    case :ets.lookup(@ets_table, origin_uri) do
      [{_origin}] -> true
      _ -> false
    end
  end

  def handle_info(:refresh, state) do
    new_origins =
      Dingen.list_allowed_origins()
      |> Enum.map(&URI.parse/1)

    # get the list of currently cached origins
    current_origins =
      :ets.tab2list(@ets_table)
      |> Enum.map(fn {origin} -> origin end)

    # insert what has to be inserted
    insert_origins = new_origins -- current_origins
    if length(insert_origins) > 0 do
      :ets.insert(@ets_table, Enum.map(insert_origins, fn origin -> {origin} end))
      Logger.info("Allowing origins #{inspect(Enum.map(insert_origins, &URI.to_string/1))}")
    end

    # delete what has to be deleted
    delete_origins = current_origins -- new_origins
    if length(delete_origins) > 0 do
      Enum.map(delete_origins, fn origin -> :ets.delete(@ets_table, origin) end)
      Logger.info("Disallowing origins #{inspect(Enum.map(delete_origins, &URI.to_string/1))}")
    end

    Process.send_after(self(), :refresh, :timer.seconds(state.refresh_after_seconds))
    {:noreply, state}
  end
end
