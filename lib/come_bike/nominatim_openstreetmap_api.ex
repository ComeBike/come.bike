defmodule ComeBike.NominatimOpenstreetmapApi do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://nominatim.openstreetmap.org")
  plug(Tesla.Middleware.JSON)

  def get_lat_lng(zip) do
    get(
      "search",
      query: [postalcode: zip, format: "json"]
    )
    |> parse_results
  end

  def get_lat_lng(street, city, state, zip) do
    get(
      "search",
      query: [street: street, city: city, state: state, postalcode: zip, format: "json"]
    )
    |> parse_results
  end

  def look_up_zip_info(zip) do
    get(
      "search",
      query: [
        postalcode: zip,
        format: "json",
        email: "joshc@digitalcak.es",
        limit: 1,
        addressdetails: 1
      ]
    )
    |> parse_results
  end

  def look_up_lat_lng(%{lat: lat, lng: lng}) do
    get(
      "reverse",
      query: [lat: lat, lon: lng, zoom: 18, email: "joshc@digitalcak.es", format: "json"]
    )
    |> parse_results
  end

  defp parse_results(%Tesla.Env{
         status: 200,
         body: [
           %{
             "lat" => lat,
             "lon" => lng,
             "address" => address
           }
           | _t
         ]
       }) do
    {:ok, %{
      lat: lat,
      lng: lng,
      address: %{
        country: address["country"],
        country_code: address["country_code"],
        state: address["state"],
        state_code: address["state_code"],
        city: address["city"],
        zip: address["postcode"]
      }
    }}
  end

  defp parse_results(%Tesla.Env{status: 200, body: [%{"lat" => lat, "lon" => lng} | _t]}) do
    {:ok, %{lat: lat, lng: lng}}
  end

  defp parse_results(_) do
    {:error, "Failed Geo lookup"}
  end
end
