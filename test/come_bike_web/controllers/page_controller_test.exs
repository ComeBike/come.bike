defmodule ComeBikeWeb.PageControllerTest do
  use ComeBikeWeb.ConnCase

  describe "index" do
    test "search for rides", %{conn: conn} do
      conn =
        get(conn, ride_path(conn, :index, ride_search: %{miles: 10, zip: "97202", type: "foo"}))

      assert html_response(conn, 200)
    end

    test "search for rides without zip", %{conn: conn} do
      conn = get(conn, ride_path(conn, :index, ride_search: %{miles: 10, type: "foo"}))

      assert html_response(conn, 200) =~ "Zip can't be b"
    end
  end
end
