defmodule ComeBikeWeb.RideControllerTest do
  use ComeBikeWeb.ConnCase
  import ComeBikeWeb.AuthCase

  alias ComeBike.Events
  import ComeBike.Factory

  setup %{conn: conn} do
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

    conn = conn |> bypass_through(ComeBikeWeb.Router, [:browser]) |> get("/")
    user = add_user("robin@example.com")
    {:ok, %{conn: conn, user: user}}
  end

  @create_attrs params_for(:ride)

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

  def fixture(:ride) do
    {:ok, ride} = Events.create_ride(@create_attrs)
    ride
  end

  describe "index" do
    test "lists all rides", %{conn: conn} do
      conn = get(conn, ride_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Rides"
    end
  end

  describe "new ride" do
    test "renders form", %{conn: conn, user: user} do
      conn = conn |> add_phauxth_session(user) |> send_resp(:ok, "/")

      conn = get(conn, ride_path(conn, :new))
      assert html_response(conn, 200) =~ "New Ride"
    end
  end

  describe "create ride" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = conn |> add_phauxth_session(user) |> send_resp(:ok, "/")

      conn = post(conn, ride_path(conn, :create), ride: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ride_path(conn, :show, id)

      conn = get(conn, ride_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Ride"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> add_phauxth_session(user) |> send_resp(:ok, "/")
      conn = post(conn, ride_path(conn, :create), ride: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Ride"
    end
  end

  describe "edit ride" do
    setup [:create_ride]

    test "renders form for editing chosen ride", %{conn: conn, ride: ride, user: user} do
      conn = conn |> add_phauxth_session(user) |> send_resp(:ok, "/")
      conn = get(conn, ride_path(conn, :edit, ride))
      assert html_response(conn, 200) =~ "Edit Ride"
    end
  end

  # TODO Fix test because only a given user can edit their own ride
  # describe "update ride" do
  #   setup [:create_ride]
  #
  #   test "redirects when data is valid", %{conn: conn, ride: ride, user: user} do
  #     conn = conn |> add_phauxth_session(user) |> send_resp(:ok, "/")
  #     conn = put(conn, ride_path(conn, :update, ride), ride: @update_attrs)
  #     assert redirected_to(conn) == ride_path(conn, :show, ride)
  #
  #     conn = get(conn, ride_path(conn, :show, ride))
  #     assert html_response(conn, 200) =~ "some updated description"
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, ride: ride, user: user} do
  #     conn = conn |> add_phauxth_session(user) |> send_resp(:ok, "/")
  #     conn = put(conn, ride_path(conn, :update, ride), ride: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit Ride"
  #   end
  # end

  describe "delete ride" do
    setup [:create_ride]

    test "deletes chosen ride", %{conn: conn, ride: ride, user: user} do
      conn = conn |> add_phauxth_session(user) |> send_resp(:ok, "/")
      conn = delete(conn, ride_path(conn, :delete, ride))
      assert redirected_to(conn) == ride_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, ride_path(conn, :show, ride))
      end)
    end
  end

  defp create_ride(_) do
    {:ok, ride: insert(:ride)}
  end
end
