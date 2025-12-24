defmodule PhxLvFeed.Feed do
  use GenServer

  alias Phoenix.PubSub

  @table :feed_messages
  @pubsub_topic "feed"

  # Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def list_messages do
    :ets.tab2list(@table)
    |> Enum.map(fn {_id, msg} -> msg end)
    |> Enum.sort_by(& &1.inserted_at)
  end

  def post(msg) do
    GenServer.cast(__MODULE__, {:post, msg})
  end

  def subscribe do
    PubSub.subscribe(PhxLvFeed.PubSub, @pubsub_topic)
  end

  # Server callbacks

  def init(_) do
    table = :ets.new(@table, [
      :named_table,
      :public,
      :set,
      read_concurrency: true
    ])

    {:ok, table}
  end

  def handle_cast({:post, msg}, state) do
    :ets.insert(@table, {msg.id, msg})
    broadcast_update()
    {:noreply, state}
  end

  defp broadcast_update do
    PubSub.broadcast(PhxLvFeed.PubSub, @pubsub_topic, {:feed_updated, list_messages()})
  end
end
