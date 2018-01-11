defmodule ComeBike.Repo.Migrations.AddGeoFieldsToRides do
  use Ecto.Migration

  def change do
    alter table(:rides) do
      add(:tz_offset, :integer)
      add(:tz_zone_id, :string)
      add(:lat, :string)
      add(:lng, :string)
    end
  end
end
