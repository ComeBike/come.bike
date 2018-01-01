defmodule ComeBike.Repo.Migrations.DropUser do
  use Ecto.Migration

  def change do
    drop(table(:users))
  end
end
