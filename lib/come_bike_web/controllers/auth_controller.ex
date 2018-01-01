defmodule ComeBikeWeb.AuthController do
  use ComeBikeWeb, :controller
  plug(Ueberauth)
  alias ComeBike.Accounts
  alias Ueberauth.Strategy.Helpers
  alias Phauxth.Login

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case auth.provider do
      :facebook ->
        # auth.extra.raw_info.user["email"]
        # auth.extra.raw_info.user["name"]
        # auth.extra.raw_info.user["id"]

        case Accounts.find_or_create_facebook_user(auth.extra.raw_info.user) do
          {:ok, user} ->
            session_id = Login.gen_session_id("F")
            Accounts.add_session(user, session_id, System.system_time(:second))

            conn
            |> Login.add_session(session_id, user.id)
            |> put_flash(:info, "You have been logged in.")
            |> redirect(to: "/")

          {:error, message} ->
            conn
            |> put_flash(:error, message)
            |> redirect(to: "/")
        end
    end
  end
end
