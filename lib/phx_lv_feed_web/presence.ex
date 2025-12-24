defmodule PhxLvFeedWeb.Presence do
  use Phoenix.Presence,
  otp_app: :phx_lv_feed,
  pubsub_server: PhxLvFeed.PubSub

  alias Phoenix.PubSub

  @presence_topic "users"

  def track_user(pid, user_id, user_name) do
    track(pid, @presence_topic, user_name, %{user_id: user_id})
  end

  def list_users do
    list(@presence_topic)
    |> Map.keys()
  end

  def subscribe do
    PubSub.subscribe(PhxLvFeed.PubSub, @presence_topic)
  end
end
