defmodule ComeBike.Events.Ride do
  use Ecto.Schema
  import Ecto.Changeset
  alias ComeBike.Events.Ride

  schema "rides" do
    field(:description, :string)
    field(:start_address, :string)
    field(:start_city, :string)
    field(:start_location_name, :string)
    field(:start_state, :string)
    field(:start_time, :naive_datetime)
    field(:start_zip, :string)
    field(:title, :string)
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
  end
end
