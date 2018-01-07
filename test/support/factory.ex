defmodule ComeBike.Factory do
  use ExMachina.Ecto, repo: ComeBike.Repo

  alias ComeBike.Events.Ride
  alias ComeBike.Accounts.User

  def ride_factory do
    %Ride{
      title: "some title",
      description: "some description",
      start_address: "some start_address",
      start_city: "some start_city",
      start_location_name: "some start_location_name",
      start_state: "some start_state",
      start_time: ~N[2010-04-17 14:00:00.000000],
      start_zip: "some start_zip",
      user: build(:user)
    }
  end

  def user_factory do
    %User{
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end
end
