defmodule ComeBikeWeb.PageController do
  use ComeBikeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
