defmodule ComeBikeWeb.PageView do
  use ComeBikeWeb, :view
  use Timex

  def render("header.index.html", assigns) do
    render(
      ComeBikeWeb.PageView,
      "header.html",
      conn: assigns.conn,
      current_user: assigns.current_user
    )

    # {:safe, "<script src=#{Digitalcakes.Router.Helpers.static_path(assigns[:conn], "/js/admin.js")} ></script>"}
  end

  def ride_date_link(ride) do
    tz = ride.tz_zone_id |> Timex.Timezone.get(ride.start_time) |> IO.inspect()
    start_time = Timex.Timezone.convert(ride.start_time, tz)

    raw(
      "<i class='fa fa-calendar'></i> " <>
        Timex.format!(start_time, "{Mshort} {D}, {YYYY} at {h12}:{m} {AM} {Zabbr}")
    )
  end
end
