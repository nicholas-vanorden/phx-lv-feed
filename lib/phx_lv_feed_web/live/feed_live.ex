defmodule PhxLvFeedWeb.FeedLive do
  use PhxLvFeedWeb, :live_view

  alias PhxLvFeed.Feed
  alias PhxLvFeedWeb.Presence

  def mount(%{"name" => name}, _session, socket) do
    user_id = UUID.uuid4()

    if connected?(socket) do
      Feed.subscribe()
      Presence.subscribe()

      Presence.track_user(
        self(),
        user_id,
        name
      )
    end

    {:ok,
      assign(socket,
        name: name,
        user_id: user_id,
        messages: Feed.list_messages(),
        users: online_users(),
        message: ""
     )}
  end

  def handle_event("post", %{"body" => body}, socket) do
    if String.trim(body) != "" do
      Feed.post(%{
        id: System.unique_integer([:positive]),
        user_id: socket.assigns.user_id,
        name: socket.assigns.name,
        body: body,
        inserted_at: System.system_time(:second)
      })
    end

    {:noreply, assign(socket, :message, "")}
  end

  def handle_event("change", %{"body" => body}, socket) do
    {:noreply, assign(socket, :message, body)}
  end

  def handle_info({:feed_updated, messages}, socket) do
    {:noreply, assign(socket, :messages, messages)}
  end

  def handle_info(
      %Phoenix.Socket.Broadcast{
        event: "presence_diff"
      },
      socket
    ) do
    {:noreply, assign(socket, :users, online_users())}
  end

  def handle_info(_msg, socket) do
    {:noreply, socket}
  end

  defp online_users do
    Presence.list_users()
  end
end
