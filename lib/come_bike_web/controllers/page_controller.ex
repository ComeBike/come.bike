defmodule ComeBikeWeb.PageController do
  use ComeBikeWeb, :controller
  alias ComeBike.Events

  def index(conn, _params) do
    rides = Events.list_rides()
    render(conn, "index.html", rides: rides)
  end
end
