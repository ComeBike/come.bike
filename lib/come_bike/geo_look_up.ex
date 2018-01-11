defmodule ComeBike.GeoLookUp do
  def get_lat_long(%{
        start_address: street,
        start_city: city,
        start_state: state,
        start_zip: zip
      }) do
    get_lat_long(%{
      "start_address" => street,
      "start_city" => city,
      "start_state" => state,
      "start_zip" => zip
    })
  end

  def get_lat_long(%{
        "start_address" => street,
        "start_city" => city,
        "start_state" => state,
        "start_zip" => zip
      }) do
    ComeBike.NominatimOpenstreetmapApi.get_lat_log(street, city, state, zip)
  end

  def get_lat_long(_), do: {:error, "Missing arguments"}

  def get_timezone(%{lat: _, lng: _} = params), do: ComeBike.GeoNamesApi.get_timezone(params)

  def get_timezone(_), do: {:error, "Missing arguments"}
end
