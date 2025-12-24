defmodule PhxLvFeed.PresenceListener do
  use GenServer

  alias PhxLvFeedWeb.Presence
  alias PhxLvFeed.Feed

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Presence.subscribe()
    {:ok, nil}
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{
          event: "presence_diff",
          payload: %{joins: joins, leaves: leaves}
        },
        state
      ) do
    Enum.each(joins, fn {name, _meta} ->
      post_system("#{name} joined the party 🎉")
    end)

    Enum.each(leaves, fn {name, _meta} ->
      post_system("#{name} left the party 👋")
    end)

    {:noreply, state}
  end

  def handle_info(_msg, state)  do
    {:noreply, state}
  end

  defp post_system(body) do
    Feed.post(%{
      id: System.unique_integer([:positive]),
      user_id: :system,
      name: "System",
      body: body,
      inserted_at: System.system_time(:second),
      system: true
    })
  end
end
