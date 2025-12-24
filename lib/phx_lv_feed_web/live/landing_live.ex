defmodule PhxLvFeedWeb.LandingLive do
  use PhxLvFeedWeb, :live_view

  alias PhxLvFeed.Feed
  alias PhxLvFeedWeb.Presence

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Feed.subscribe()
    end

    {:ok,
      assign(socket,
        users: online_users(),
        name: ""
      )}
  end

  def handle_event("join", %{"name" => name}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/feed?name=#{name}")}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, :users, online_users())}
  end

  def handle_info(_msg, socket) do
    {:noreply, socket}
  end

  defp online_users do
    Presence.list_users()
  end
end
