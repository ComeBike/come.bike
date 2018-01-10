defmodule ComeBikeWeb.PageController do
  use ComeBikeWeb, :controller
  alias ComeBike.Events

  def index(conn, _params) do
    rides = Events.list_rides()
    render(conn, "index.html", rides: rides)
  end

  def tos(conn, _params) do
    render(conn, "tos.html")
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end
end
