defmodule DingenWeb.DynamicOrigin.Plug do
  import Plug.Conn, only: [request_url: 1, resp: 3, halt: 1]
  import DingenWeb.DynamicOrigin, only: [origin_allowed?: 1]

  def init(options), do: options

  def call(conn, _options) do
    conn
    |> request_url()
    |> origin_allowed?()
    |> case do
      true ->
        conn
      false ->
        conn
        |> resp(:forbidden, "")
        |> halt()
    end
  end
end
