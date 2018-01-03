defmodule ComeBikeWeb.PageView do
  use ComeBikeWeb, :view

  def render("header.index.html", assigns) do
    render(
      ComeBikeWeb.PageView,
      "header.html",
      conn: assigns.conn,
      current_user: assigns.current_user
    )

    # {:safe, "<script src=#{Digitalcakes.Router.Helpers.static_path(assigns[:conn], "/js/admin.js")} ></script>"}
  end
end
