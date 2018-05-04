defmodule DingenWeb.DynamicHost.Transport do
  alias DingenWeb.DynamicHost

  require Logger

  # Taken from Phoenix.Socket.Transport.check_origin/4
  @doc """
  Checks the origin request header against the list of allowed origins.

  Should be called by transports before connecting when appropriate.
  If the origin header matches the allowed origins, no origin header was
  sent or no origin was configured, it will return the given connection.

  Otherwise a 403 Forbidden response will be sent and the connection halted.
  It is a noop if the connection has been halted.
  """
  def check_origin(conn, handler, endpoint, opts, sender \\ &Plug.Conn.send_resp/1)

  def check_origin(%Plug.Conn{halted: true} = conn, _handler, _endpoint, _opts, _sender),
    do: conn

  def check_origin(conn, _handler, _endpoint, _opts, sender) do
    import Plug.Conn
    origin = get_req_header(conn, "origin") |> List.first

    cond do
      is_nil(origin) ->
        conn
      origin_allowed?(URI.parse(origin)) ->
        conn
      true ->
        Logger.error "Websocket request's origin is not allowed; origin: #{origin}"
        resp(conn, :forbidden, "")
        |> sender.()
        |> halt()
    end
  end

  defp origin_allowed?(%URI{host: nil}),
    do: true
  defp origin_allowed?(%URI{host: origin_host}),
    do: DynamicHost.host_allowed?(origin_host)
end
