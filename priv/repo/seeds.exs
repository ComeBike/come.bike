# # Script for populating the database. You can run it as:
# #
# #     mix run priv/repo/seeds.exs
# #
# # It is also run when you use the command `mix ecto.setup`
# #
#
# # users = [
# #   %{email: "test@test.com", password: "password"}
# # ]
# #
# # for user <- users do
# #   {:ok, _} = ComeBike.Accounts.create_user(user)
# # end
#
# {:ok, txt} = File.read("priv/repo/US.txt")
#
# # Parse the rows
# rows = String.split(txt, "\n")
#
# # Drop the first row
# [_ignore | rows] = rows
#
# require IEx
# IEx.pry()
#
# # Parse zip, lat, lng
# defmodule SeedZipParser do
#   def parse_rows(rows, parsed_rows \\ [])
#
#   def parse_rows([], parsed_rows), do: parsed_rows
#
#   def parse_rows(rows, parsed_rows) do
#     [h | t] = rows
#
#     case h do
#       "" ->
#         SeedZipParser.parse_rows(t, parsed_rows)
#
#       _ ->
#         [country_code, zip, city, state, state_code, county, _, _, _, lat, log, _] =
#           String.split(h, "\t")
#
#         SeedZipParser.parse_rows(t, [
#           %{
#             zip: zip,
#             lat: lat,
#             lng: log,
#             city: city,
#             state: state,
#             state_code: state_code,
#             country_code: country_code,
#             county: county
#           }
#           | parsed_rows
#         ])
#     end
#   end
# end
#
# rows = SeedZipParser.parse_rows(rows)
#
# # Loop over rows and stub the db
# alias ComeBike.Events.Zip
# alias ComeBike.Repo
#
# for r <- rows do
#   Zip.changeset(%Zip{}, r) |> Repo.insert()
# end
#
# # Drop AE, AP, or AA ZIP Code since Overseas military addresses
# import Ecto.Query, only: [from: 2]
# from(r in ComeBike.Events.Zip, where: r.state == is_nil(r.state)) |> ComeBike.Repo.delete_all()
#
#
# {:ok, cities} = File.read("priv/repo/geonames-all-cities-with-a-population-1000.csv")
# rows = String.split(cities, "\r\n")
#
# # Drop the first row
# [_ignore | rows] = rows
#
# # Parse zip, lat, lng
# defmodule SeedZipParser do
#   def parse_rows(rows, parsed_rows \\ [])
#
#   def parse_rows([], parsed_rows), do: parsed_rows
#
#   def parse_rows(rows, parsed_rows) do
#     [h | t] = rows
#
#     case h do
#       "" ->
#         SeedZipParser.parse_rows(t, parsed_rows)
#
#       _ ->
#         [_, city, _, _, _, _, _, _, contry_code, _, state_code, _, _, _, _, _, _, tz, _, _, _] =
#           String.split(h, ";")
#
#         SeedZipParser.parse_rows(t, [
#           %{
#             city: city,
#             contry_code: contry_code,
#             state_code: state_code,
#             tz: tz
#           }
#           | parsed_rows
#         ])
#     end
#   end
# end
#
# rows = SeedZipParser.parse_rows(rows)

# import Ecto.Query, only: [from: 2]
#
# require IEx
# IEx.pry()

# from(r in ComeBike.Events.Zip, where: r.tz_id == is_nil(r.tz_id), limit: 2000) |> ComeBike.Repo.all

# for r <- rows do
#   results =
#     from(z in ComeBike.Events.Zip, where: z.state_code == ^r.state_code and z.city == ^r.city)
#     |> ComeBike.Repo.update_all(set: [tz_id: r.tz])
# end
#
# Used to convert all the lat lngs to a geom point.
# defmodule ComeBike.ConvertIntoPoint do
#   alias ComeBike.Repo
#   alias ComeBike.Events.Zip
#   import Ecto.Query
#
#   def run do
#     Repo.transaction(
#       fn ->
#         from(z in Zip)
#         |> Repo.stream()
#         |> Task.async_stream(&update_geo/1, max_concurrency: 10)
#         |> Stream.run()
#       end,
#       timeout: 100_000_000
#     )
#   end
#
#   def update_geo(zip) do
#     Zip.changeset(zip, %{geom: %Geo.Point{coordinates: {zip.lat, zip.lng}, srid: 4326}})
#     |> Repo.update()
#     |> IO.inspect()
#   end
# end

## Seed remaining missing tz ids for zips.

# limit 2000 per hour.

import Ecto.Query

zips =
  from(z in ComeBike.Events.Zip, where: is_nil(z.tz_id), limit: 1000)
  |> ComeBike.Repo.all()

Enum.each(zips, fn zip ->
  {:ok, %{time_zone_id: tz_id}} = ComeBike.GeoNamesApi.get_timezone(%{lat: zip.lat, lng: zip.lng})

  cs = ComeBike.Events.Zip.changeset(zip, %{tz_id: tz_id})

  ComeBike.Repo.update(cs) |> IO.inspect()
end)
