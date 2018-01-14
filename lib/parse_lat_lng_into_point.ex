defmodule ComeBike.ConvertIntoPoint do
  alias ComeBike.Repo
  alias ComeBike.Events.Ride
  import Ecto.Query

  def run do
    Repo.transaction(
      fn ->
        from(r in Ride)
        |> Repo.stream()
        |> Task.async_stream(&update_geo/1, max_concurrency: 10)
        |> Stream.run()
      end,
      timeout: 100_000_000
    )
  end

  def update_geo(zip) do
    Ride.changeset(zip, %{geom: %Geo.Point{coordinates: {zip.lat, zip.lng}, srid: 4326}})
    |> Repo.update()
  end
end
