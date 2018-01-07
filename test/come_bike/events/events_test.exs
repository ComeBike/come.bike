defmodule ComeBike.EventsTest do
  use ComeBike.DataCase

  alias ComeBike.Events

  import ComeBike.Factory

  describe "rides" do
    alias ComeBike.Events.Ride

    @update_attrs %{
      description: "some updated description",
      start_address: "some updated start_address",
      start_city: "some updated start_city",
      start_location_name: "some updated start_location_name",
      start_state: "some updated start_state",
      start_time: ~N[2011-05-18 15:01:01.000000],
      start_zip: "some updated start_zip",
      title: "some updated title"
    }
    @invalid_attrs %{
      description: nil,
      start_address: nil,
      start_city: nil,
      start_location_name: nil,
      start_state: nil,
      start_time: nil,
      start_zip: nil,
      title: nil
    }

    def ride_fixture() do
      insert(:ride)
      |> ComeBike.Repo.preload(:user)
    end

    test "list_rides/0 returns all rides" do
      ride = ride_fixture()
      assert Events.list_rides() == [ride]
    end

    test "get_ride!/1 returns the ride with given id" do
      ride = ride_fixture()
      assert Events.get_ride!(ride.id) == ride
    end

    test "create_ride/1 with valid data creates a ride" do
      assert {:ok, %Ride{} = ride} = Events.create_ride(params_for(:ride))
      assert ride.description == "some description"
      assert ride.start_address == "some start_address"
      assert ride.start_city == "some start_city"
      assert ride.start_location_name == "some start_location_name"
      assert ride.start_state == "some start_state"
      assert ride.start_time == ~N[2010-04-17 14:00:00.000000]
      assert ride.start_zip == "some start_zip"
      assert ride.title == "some title"
    end

    test "create_ride/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_ride(@invalid_attrs)
    end

    test "update_ride/2 with valid data updates the ride" do
      ride = ride_fixture()
      assert {:ok, ride} = Events.update_ride(ride, @update_attrs)
      assert %Ride{} = ride
      assert ride.description == "some updated description"
      assert ride.start_address == "some updated start_address"
      assert ride.start_city == "some updated start_city"
      assert ride.start_location_name == "some updated start_location_name"
      assert ride.start_state == "some updated start_state"
      assert ride.start_time == ~N[2011-05-18 15:01:01.000000]
      assert ride.start_zip == "some updated start_zip"
      assert ride.title == "some updated title"
    end

    test "update_ride/2 with invalid data returns error changeset" do
      ride = ride_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_ride(ride, @invalid_attrs)
      assert ride == Events.get_ride!(ride.id)
    end

    test "delete_ride/1 deletes the ride" do
      ride = ride_fixture()
      assert {:ok, %Ride{}} = Events.delete_ride(ride)
      require IEx
      IEx.pry()
      assert_raise Ecto.NoResultsError, fn -> Events.get_ride!(ride.id) end
    end

    test "change_ride/1 returns a ride changeset" do
      ride = ride_fixture()
      assert %Ecto.Changeset{} = Events.change_ride(ride)
    end
  end
end
