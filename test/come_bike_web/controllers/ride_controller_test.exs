defmodule ComeBikeWeb.RideControllerTest do
  use ComeBikeWeb.ConnCase

  alias ComeBike.Events

  @create_attrs %{description: "some description", start_address: "some start_address", start_city: "some start_city", start_location_name: "some start_location_name", start_state: "some start_state", start_time: ~N[2010-04-17 14:00:00.000000], start_zip: "some start_zip", title: "some title"}
  @update_attrs %{description: "some updated description", start_address: "some updated start_address", start_city: "some updated start_city", start_location_name: "some updated start_location_name", start_state: "some updated start_state", start_time: ~N[2011-05-18 15:01:01.000000], start_zip: "some updated start_zip", title: "some updated title"}
  @invalid_attrs %{description: nil, start_address: nil, start_city: nil, start_location_name: nil, start_state: nil, start_time: nil, start_zip: nil, title: nil}

  def fixture(:ride) do
    {:ok, ride} = Events.create_ride(@create_attrs)
    ride
  end

  describe "index" do
    test "lists all rides", %{conn: conn} do
      conn = get conn, ride_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Rides"
    end
  end

  describe "new ride" do
    test "renders form", %{conn: conn} do
      conn = get conn, ride_path(conn, :new)
      assert html_response(conn, 200) =~ "New Ride"
    end
  end

  describe "create ride" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, ride_path(conn, :create), ride: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ride_path(conn, :show, id)

      conn = get conn, ride_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Ride"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, ride_path(conn, :create), ride: @invalid_attrs
      assert html_response(conn, 200) =~ "New Ride"
    end
  end

  describe "edit ride" do
    setup [:create_ride]

    test "renders form for editing chosen ride", %{conn: conn, ride: ride} do
      conn = get conn, ride_path(conn, :edit, ride)
      assert html_response(conn, 200) =~ "Edit Ride"
    end
  end

  describe "update ride" do
    setup [:create_ride]

    test "redirects when data is valid", %{conn: conn, ride: ride} do
      conn = put conn, ride_path(conn, :update, ride), ride: @update_attrs
      assert redirected_to(conn) == ride_path(conn, :show, ride)

      conn = get conn, ride_path(conn, :show, ride)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, ride: ride} do
      conn = put conn, ride_path(conn, :update, ride), ride: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Ride"
    end
  end

  describe "delete ride" do
    setup [:create_ride]

    test "deletes chosen ride", %{conn: conn, ride: ride} do
      conn = delete conn, ride_path(conn, :delete, ride)
      assert redirected_to(conn) == ride_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, ride_path(conn, :show, ride)
      end
    end
  end

  defp create_ride(_) do
    ride = fixture(:ride)
    {:ok, ride: ride}
  end
end
