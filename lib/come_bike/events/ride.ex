defmodule ComeBike.Events.Ride do
  use Ecto.Schema
  import Ecto.Changeset
  alias ComeBike.Events.Ride

  alias ComeBike.GeoLookUp

  schema "rides" do
    field(:description, :string)
    field(:start_address, :string)
    field(:start_city, :string)
    field(:start_location_name, :string)
    field(:start_state, :string)
    field(:start_time, :naive_datetime)
    field(:start_zip, :string)
    field(:title, :string)
    field(:lat, :string)
    field(:lng, :string)
    field(:tz_offset, :integer)
    field(:tz_zone_id, :string)
    belongs_to(:user, ComeBike.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(%Ride{} = ride, attrs) do
    ride
    |> cast(attrs, [
      :title,
      :description,
      :start_time,
      :start_location_name,
      :start_address,
      :start_city,
      :start_state,
      :start_zip
    ])
    |> validate_required([
      :title,
      :description,
      :start_time,
      :start_location_name,
      :start_address,
      :start_city,
      :start_state,
      :start_zip
    ])
  end

  @doc false
  def new_changeset(%Ride{} = ride, attrs) do
    ride
    |> changeset(attrs)
    |> put_assoc(:user, attrs["user"])
    |> put_lat_long(attrs)
    |> put_timezone()
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
end
