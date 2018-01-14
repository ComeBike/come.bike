defmodule ComeBike.Events.SearchRides do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  embedded_schema do
    field(:type, :string)
    field(:miles, :integer)
    field(:zip, :string)
  end

  def changeset(%SearchRides{} = search_ride, attrs) do
    search_ride
    |> cast(attrs, [:type, :miles, :zip])
    |> validate_required([:type, :miles, :zip])
  end
end
