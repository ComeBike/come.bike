defmodule ComeBike.EventsTest do
  use ComeBike.DataCase

  alias ComeBike.Events

  import ComeBike.Factory

  setup do
    Tesla.Mock.mock(fn
      %{method: :get, url: "http://api.geonames.org/timezoneJSON"} ->
        {
          200,
          %{"Content-Type" => "application/json"},
          ~s({"sunrise":"2018-01-12 07:48","lng":-122.6765,"countryCode":"US","gmtOffset":-8,"rawOffset":-8,"sunset":"2018-01-12 16:49","timezoneId":"America/Los_Angeles","dstOffset":-7,"countryName":"United States","time":"2018-01-12 09:58","lat":45.52311})
        }

      %{method: :get, url: "http://nominatim.openstreetmap.org/search"} ->
        {
          200,
          %{"Content-Type" => "application/json"},
          ~s([{"place_id":"180992955","licence":"Data © OpenStreetMap contributors, ODbL 1.0. http:\/\/www.openstreetmap.org\/copyright","boundingbox":["45.483387638255","45.483487638255","-122.63903580617","-122.63893580617"],"lat":"45.4834376382547","lon":"-122.638985806172","display_name":"Reed, Oregon, 97202, United States of America","class":"place","type":"postcode","importance":0.26625}])
        }
    end)

    :ok
  end

  describe "rides" do
    alias ComeBike.Events.Ride
    @create_attrs params_for(:ride)
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
      assert {:ok, %Ride{} = ride} = Events.create_ride(@create_attrs)
      assert ride.description == @create_attrs.description
      assert ride.start_address == @create_attrs.start_address
      assert ride.start_city == @create_attrs.start_city
      assert ride.start_location_name == @create_attrs.start_location_name
      assert ride.start_state == @create_attrs.start_state
      assert ride.start_time == @create_attrs.start_time
      assert ride.start_zip == @create_attrs.start_zip
      assert ride.title == @create_attrs.title
      assert ride.lat != nil
      assert ride.lng != nil
      assert ride.tz_offset != nil
      assert ride.tz_zone_id != nil
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
      assert_raise Ecto.NoResultsError, fn -> Events.get_ride!(ride.id) end
    end

    test "change_ride/1 returns a ride changeset" do
      ride = ride_fixture()
      assert %Ecto.Changeset{} = Events.change_ride(ride)
    end
  end
end
