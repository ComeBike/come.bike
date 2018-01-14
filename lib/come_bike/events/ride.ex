defmodule ComeBike.Events.Ride do
  use Ecto.Schema
  use Timex

  import Ecto.Changeset
  alias ComeBike.Events.Ride

  alias ComeBike.GeoLookUp

  schema "rides" do
    field(:description, :string)
    field(:short_description, :string)
    field(:start_address, :string)
    field(:start_city, :string)
    field(:start_location_name, :string)
    field(:start_state, :string)
    field(:start_time, Timex.Ecto.DateTime, default: Timex.now())
    field(:start_time_local, :string)

    field(:start_zip, :string)
    field(:title, :string)
    field(:lat, :string)
    field(:lng, :string)
    field(:tz_offset, :integer)
    field(:tz_zone_id, :string)
    field(:geom, Geo.Point)
    belongs_to(:user, ComeBike.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(%Ride{} = ride, attrs) do
    ride
    |> cast(attrs, [
      :title,
      :description,
      :short_description,
      :start_time_local,
      :start_location_name,
      :start_address,
      :start_city,
      :start_state,
      :start_zip,
      :geom
    ])
    |> validate_required([
      :title,
      :description,
      :short_description,
      :start_time_local,
      :start_location_name,
      :start_address,
      :start_city,
      :start_state,
      :start_zip
    ])
    |> put_lat_long(attrs)
    |> put_timezone()
    |> put_start_time(attrs)
  end

  @doc false
  def new_changeset(%Ride{} = ride, attrs) do
    ride
    |> changeset(attrs)
    |> put_assoc(:user, attrs["user"])
  end

  defp put_lat_long(cs, params) do
    case cs do
      %{valid?: true} ->
        case GeoLookUp.get_lat_long(params) do
          {:ok, %{lat: lat, lng: lng}} ->
            cs
            |> put_change(:lat, lat)
            |> put_change(:lng, lng)

          {:error, _message} ->
            # Raise Error
            cs
        end

      _ ->
        cs
    end
  end

  @doc false
  defp put_timezone(%{changes: %{lat: lat, lng: lng}} = cs) do
    case cs do
      %{valid?: true} ->
        case GeoLookUp.get_timezone(%{lat: lat, lng: lng}) do
          {:ok, %{raw_offset: raw_offset, time_zone_id: time_zone_id}} ->
            cs
            |> put_change(:tz_offset, raw_offset)
            |> put_change(:tz_zone_id, time_zone_id)

          {:error, _message} ->
            # Raise Error
            cs
        end

      _ ->
        cs
    end
  end

  defp put_timezone(cs), do: cs

  defp put_start_time(%{changes: %{tz_zone_id: tz_zone_id}} = cs, %{
         "start_time_local" => start_time_local
       }) do
    case cs do
      %{valid?: true} ->
        dt = Timex.parse!(start_time_local, "%m/%d/%Y %l:%M %p", :strftime)
        utc_dt = Timex.to_datetime(dt, tz_zone_id) |> Timex.to_datetime("Etc/UTC")

        cs
        |> put_change(:start_time, utc_dt)

      _ ->
        cs
    end
  end

  defp put_start_time(%{changes: %{tz_zone_id: tz_zone_id}} = cs, attrs) do
    case cs do
      %{valid?: true} ->
        dt =
          Timex.parse!(
            attrs["start_time_local"] || attrs[:start_time_local],
            "%m/%d/%Y %l:%M %p",
            :strftime
          )

        utc_dt = Timex.to_datetime(dt, tz_zone_id) |> Timex.to_datetime("Etc/UTC")

        cs
        |> put_change(:start_time, utc_dt)

      _ ->
        cs
    end
  end

  defp put_start_time(cs, _attrs), do: cs
end
