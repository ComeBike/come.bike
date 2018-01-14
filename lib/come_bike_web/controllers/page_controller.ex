defmodule ComeBikeWeb.PageController do
  use ComeBikeWeb, :controller
  alias ComeBike.Events
  alias ComeBike.Events.SearchRides

  # data = %{
  #   zip: conn.cookies["search_zip"],
  #   miles: conn.cookies["search_miles"],
  #   type: conn.cookies["search_type"],
  #   lat: conn.cookies["search_lat"] || "",
  #   lng: conn.cookies["search_lng"] || ""
  # }
  #
  # types = %{type: :string, miles: :string, zip: :string, lat: :string, lng: :string}
  #
  # search_form_cs =
  #   {data, types}
  #   |> Ecto.Changeset.cast(params, Map.keys(types))
  #   |> put_lat_long()
  #
  # case search_form_cs do
  #   %{changes: %{miles: miles}, valid?: true} ->
  #     rides =
  #       ComeBike.Search.find_by_zip_in_n_miles(%{"miles" => data.miles, "zip" => data.zip})
  #
  #     conn =
  #       conn
  #       |> Plug.Conn.put_resp_cookie("search_miles", miles)
  #
  #     render(conn, "index.html", rides: rides, search_form_cs: search_form_cs)
  #
  #   %{changes: changes, valid?: true} ->
  #     # Enum.each(mymap, fn({k, x}) ->
  #     #
  #     # end)
  #
  #     conn =
  #       conn
  #       |> Plug.Conn.put_resp_cookie("search_zip", params["zip"])
  #       |> Plug.Conn.put_resp_cookie("search_type", params["type"])
  #       |> Plug.Conn.put_resp_cookie("search_miles", params["miles"])
  #
  #     # |> Plug.Conn.put_resp_cookie("search_lat", params["lat"])
  #     # |> Plug.Conn.put_resp_cookie("search_lng", params["lng"])
  #
  #     rides =
  #       ComeBike.Search.find_by_zip_in_n_miles(%{"miles" => data.miles, "zip" => data.zip})
  #
  #     render(conn, "index.html", rides: rides, search_form_cs: search_form_cs)
  #
  #   _ ->
  #     render(
  #       conn,
  #       "index.html",
  #       rides: %{},
  #       search_form_cs: %{search_form_cs | action: :insert}
  #     )
  # end
  # end

  def index(conn, _param) do
    # data = %{
    #   zip: conn.cookies["search_zip"],
    #   miles: conn.cookies["search_miles"],
    #   type: conn.cookies["search_type"],
    #   lat: conn.cookies["search_lat"] || "",
    #   lng: conn.cookies["search_lng"] || ""
    # }
    #
    # types = %{type: :string, miles: :string, zip: :string, lat: :string, lng: :string}
    #
    # search_form_cs =
    #   {data, types}
    #   |> Ecto.Changeset.cast(%{}, Map.keys(types))
    #
    # # Events.todays_rides()
    #
    # rides = ComeBike.Search.find_by_zip_in_n_miles(%{"miles" => data.miles, "zip" => data.zip})
    # render(conn, "index.html", rides: rides, search_form_cs: search_form_cs)

    changeset = SearchRides.changeset(%SearchRides{}, %{})

    render(conn, "index.html", rides: [], search_rides: changeset)
  end

  def tos(conn, _params) do
    render(conn, "tos.html")
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end

  defp put_lat_long(cs) do
    case cs do
      %{changes: %{zip: zip}} ->
        case ComeBike.NominatimOpenstreetmapApi.get_lat_lng(zip) do
          {:ok, %{lat: lat, lng: lng}} ->
            cs
            |> Ecto.Changeset.put_change(:lat, lat)
            |> Ecto.Changeset.put_change(:lng, lng)

          _ ->
            cs
            |> Ecto.Changeset.add_error(:zip, "Error looking up zip")
        end

      _ ->
        cs
    end
  end
end
