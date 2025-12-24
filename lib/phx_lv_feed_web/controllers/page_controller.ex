defmodule PhxLvFeedWeb.PageController do
  use PhxLvFeedWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
