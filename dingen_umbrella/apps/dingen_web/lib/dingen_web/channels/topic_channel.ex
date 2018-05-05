defmodule DingenWeb.TopicChannel do
  use Phoenix.Channel

  def join("topic:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("topic:subtopic", _params, socket) do
    {:ok, socket}
  end
  def join("topic:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
