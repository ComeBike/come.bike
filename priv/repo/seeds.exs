# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

users = [
  %{email: "test@test.com", password: "password"}
]

for user <- users do
  {:ok, _} = ComeBike.Accounts.create_user(user)
end
