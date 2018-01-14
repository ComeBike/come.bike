defmodule ComeBike.Factory do
  use ExMachina.Ecto, repo: ComeBike.Repo

  alias ComeBike.Events.Ride
  alias ComeBike.Accounts.User

  def ride_factory do
    %Ride{
      title: "Generic Bike Ride",
      description: "Habuere inseruitque beati, at unam ingemuit quis fama in vinci, Andromedan.
Invenit adiuvat exceptas armos herede: est cessant exercet aureus incessit
inania, tristes ferae, suo funere? Sub valuere, trunco, habebas vix tendere
sonarent; Io tibi cedemus de tumulum formamque Dodonaeo. Pondere sua digitis
Rhodiae fovet",
      start_address: "1000 SW Naito Pkwy",
      start_city: "Portland",
      start_location_name: "Salmon Street Fountain",
      start_state: "OR",
      start_time_local: "01/18/2018 9:07 PM",
      start_zip: "97202",
      user: build(:user)
    }
  end

  def user_factory do
    %User{
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end
end
