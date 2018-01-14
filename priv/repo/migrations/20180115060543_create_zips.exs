defmodule ComeBike.Repo.Migrations.CreateZips do
  use Ecto.Migration

  def change do
    create table(:zips) do
      add(:zip, :string, null: false)
      add(:lat, :string, null: false)
      add(:lng, :string, null: false)
      add(:city, :string)
      add(:state, :string)
      add(:state_code, :string)
      add(:country, :string)
      add(:country_code, :string)
      add(:tz_id, :string)
      add(:boundingbox, :string)

      timestamps()
    end

    create(index(:zips, [:zip]))
  end
end
