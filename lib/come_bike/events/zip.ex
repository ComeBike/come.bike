defmodule ComeBike.Events.Zip do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]

  import Ecto.Changeset
  alias __MODULE__

  schema "zips" do
    field(:zip, :string)
    field(:city, :string)
    field(:state, :string)
    field(:state_code, :string)
    field(:country, :string)
    field(:country_code, :string)
    field(:lat, :string)
    field(:lng, :string)
    field(:tz_id, :string)
    field(:boundingbox, {:array, :string})
    field(:geom, Geo.Point)
    timestamps()
  end

  def changeset(%Zip{} = zip, attrs) do
    zip
    |> cast(attrs, [
      :zip,
      :city,
      :state,
      :state_code,
      :country,
      :country_code,
      :lat,
      :lng,
      :tz_id,
      :boundingbox,
      :geom
    ])
    |> validate_required([
      :zip,
      :lat,
      :lng
    ])
  end

  def within(query, point, radius_in_m) do
    {lng, lat} = point.coordinates
    radius_in_m = radius_in_m * 1609.344

    from(
      zip in query,
      where:
        fragment(
          "ST_DWithin(
            ?::geography,
            ST_SetSRID( ST_MakePoint(?, ?), ?),
            ?)",
          zip.geom,
          ^lng,
          ^lat,
          ^point.srid,
          ^radius_in_m
        )
    )
  end

  def order_by_nearest(query, point) do
    {lng, lat} = point.coordinates

    from(
      z in query,
      order_by:
        fragment("? <-> ST_SetSRID(ST_MakePoint(?,?), ?)", z.geom, ^lng, ^lat, ^point.srid)
    )
  end
end
