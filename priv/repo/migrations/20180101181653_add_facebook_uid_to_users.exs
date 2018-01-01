defmodule ComeBike.Repo.Migrations.AddFacebookUidToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:facebook_uid, :string)
    end
  end
end
