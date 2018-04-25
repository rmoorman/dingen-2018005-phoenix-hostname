defmodule DingenWeb.PageController do
  use DingenWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
