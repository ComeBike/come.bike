defmodule ComeBike.Repo.Migrations.AddShortDescriptionToRides do
  use Ecto.Migration

  def change do
    alter table(:rides) do
      add(:short_description, :string)
    end
  end
end
