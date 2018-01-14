defmodule ComeBike.Search do
  import Ecto.Query, warn: false
  alias ComeBike.Repo
  alias ComeBike.Events.Zip
  alias ComeBike.Events.Ride
  # alias ComeBike.Events.Ride

  def find_by_zip_in_n_miles(%{"zip" => zip, "miles" => miles}) do
    zip =
      Zip
      |> Repo.get_by(zip: zip)
      |> return_or_create_zip(zip)
      |> IO.inspect()

    {miles, _} = miles |> Integer.parse()

    IO.puts("FOO")

    from(r in Ride, preload: [:user])
    |> IO.inspect()
    |> Zip.within(zip.geom, miles)
    |> Zip.order_by_nearest(zip.geom)
    |> Repo.all()
  end

  defp return_or_create_zip(nil, zip) do
    case ComeBike.NominatimOpenstreetmapApi.look_up_zip_info(zip) do
      {:error, "Failed Geo lookup"} ->
        # Cant look up location
        nil

      {:ok, %{address: address} = attrs} ->
        {:ok, zip} =
          Zip.changeset(%Zip{}, attrs |> Map.merge(address))
          |> Repo.insert()

        zip

      {:ok, %{lat: _lat, lng: _lng} = attrs} ->
        attrs = attrs |> Map.put(:zip, zip)

        {:ok, zip} =
          Zip.changeset(%Zip{}, attrs)
          |> Repo.insert()

        zip
    end
  end

  defp return_or_create_zip(%Zip{} = zip, _), do: zip
end
