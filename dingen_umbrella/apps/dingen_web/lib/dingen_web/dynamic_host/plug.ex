defmodule DingenWeb.DynamicHost.Plug do
  import Plug.Conn, only: [resp: 3, halt: 1]
  import DingenWeb.DynamicHost, only: [host_allowed?: 1]

  def init(options), do: options

  def call(conn, _options) do
    if not host_allowed?(conn.host) do
      conn
      |> resp(:forbidden, "")
      |> halt()
    else
      conn
    end
  end
end
