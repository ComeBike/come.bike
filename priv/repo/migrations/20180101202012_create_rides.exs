defmodule ComeBike.Repo.Migrations.CreateRides do
  use Ecto.Migration

  def change do
    create table(:rides) do
      add(:title, :string)
      add(:description, :text)
      add(:start_time, :naive_datetime)
      add(:start_location_name, :string)
      add(:start_address, :string)
      add(:start_city, :string)
      add(:start_state, :string)
      add(:start_zip, :string)
      add(:user_id, references(:users))

      timestamps()
    end
  end
end
