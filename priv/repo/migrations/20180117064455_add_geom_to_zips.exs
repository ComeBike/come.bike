defmodule ComeBike.Repo.Migrations.AddGeomToZips do
  use Ecto.Migration

  def change do
    alter table("zips") do
      add(:geom, :geometry)
    end

    create(index("zips", [:geom]))
  end
end
