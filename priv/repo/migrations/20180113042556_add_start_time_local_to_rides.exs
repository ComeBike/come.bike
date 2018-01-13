defmodule ComeBike.Repo.Migrations.AddStartTimeLocalToRides do
  use Ecto.Migration

  def change do
    alter table(:rides) do
      add(:start_time_local, :string)
    end
  end
end
