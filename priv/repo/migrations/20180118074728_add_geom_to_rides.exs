defmodule ComeBike.Repo.Migrations.AddGeomToRides do
  use Ecto.Migration

  def change do
    alter table("rides") do
      add(:geom, :geometry)
    end

    create(index("rides", [:geom]))
  end
end
