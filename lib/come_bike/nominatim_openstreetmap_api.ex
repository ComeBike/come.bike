defmodule ComeBike.NominatimOpenstreetmapApi do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://nominatim.openstreetmap.org")
  plug(Tesla.Middleware.JSON)

  def get_lat_log(street, city, state, zip) do
    get(
      "search",
      query: [street: street, city: city, state: state, postalcode: zip, format: "json"]
    )
    |> parse_results
  end

  defp parse_results(%Tesla.Env{status: 200, body: [%{"lat" => lat, "lon" => lng} | _t]}) do
    {:ok, %{lat: lat, lng: lng}}
  end

  defp parse_results(_) do
    {:error, "Failed Geo lookup"}
  end
end
