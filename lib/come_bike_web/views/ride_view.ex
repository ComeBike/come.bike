defmodule ComeBikeWeb.RideView do
  use ComeBikeWeb, :view

  def encode_address(%{
        start_location_name: start_location_name,
        start_address: start_address,
        start_city: start_city,
        start_state: start_state,
        start_zip: start_zip
      }) do
    start_address <> "+" <> start_city <> "+" <> start_state <> "+" <> start_zip
  end

  def ride_date_link(ride) do
    tz = ride.tz_zone_id |> Timex.Timezone.get(ride.start_time) |> IO.inspect()
    start_time = Timex.Timezone.convert(ride.start_time, tz)

    raw(
      "<i class='fa fa-calendar'></i> " <>
        Timex.format!(start_time, "{Mshort} {D}, {YYYY} at {h12}:{m} {am} {Zabbr}")
    )
  end
end
