defmodule ComeBike.GeoNamesApi do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://api.geonames.org")
  plug(Tesla.Middleware.JSON)

  def get_timezone(%{lat: lat, lng: lng}) do
    get(
      "timezoneJSON",
      query: [lat: lat, lng: lng, username: System.get_env("COME_BIKE") || "${COME_BIKE}"]
    )
    |> parse_results
  end

  defp parse_results(%Tesla.Env{
         status: 200,
         body: %{"rawOffset" => raw_offset, "timezoneId" => time_zone_id}
       }) do
    {:ok, %{raw_offset: raw_offset, time_zone_id: time_zone_id}}
  end

  defp parse_results(_) do
    {:error, "Failed Timezone lookup"}
  end
end
