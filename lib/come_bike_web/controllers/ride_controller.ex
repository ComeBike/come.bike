defmodule ComeBikeWeb.RideController do
  use ComeBikeWeb, :controller

  alias ComeBike.Events
  alias ComeBike.Events.{Ride, SearchRides}

  import ComeBikeWeb.Authorize
  plug(:user_check when action in [:new, :create, :edit, :update, :delete])

  def search(conn, %{"search_rides" => params}) do
    changeset = SearchRides.changeset(%SearchRides{}, params)

    case Events.search_rides(params) do
      {:ok, rides} ->
        render(conn, "index.html", rides: rides, search_rides: %{changeset | action: :searched})

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> render("index.html", rides: [], search_rides: %{changeset | action: :searched})
    end
  end

  def index(conn, _params) do
    cs = ComeBike.Events.SearchRides.changeset(%ComeBike.Events.SearchRides{}, %{})
    rides = Events.list_rides()
    render(conn, "index.html", rides: rides, search_rides: cs)
  end

  def new(conn, _params) do
    changeset = Events.change_ride(%Ride{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%Plug.Conn{assigns: %{current_user: current_user}} = conn, %{"ride" => ride_params}) do
    params =
      ride_params
      |> Map.merge(%{"user" => current_user})

    case Events.create_ride(params) do
      {:ok, ride} ->
        conn
        |> put_flash(:info, "Ride created successfully.")
        |> redirect(to: ride_path(conn, :show, ride))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ride = Events.get_ride!(id)
    render(conn, "show.html", ride: ride)
  end

  def edit(%Plug.Conn{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    ride = Events.get_ride!(id)
    changeset = Events.change_ride(ride)
    render(conn, "edit.html", ride: ride, changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{current_user: current_user}} = conn, %{
        "id" => id,
        "ride" => ride_params
      }) do
    ride = Events.get_ride_by_user!(id, current_user)

    case Events.update_ride(ride, ride_params) do
      {:ok, ride} ->
        conn
        |> put_flash(:info, "Ride updated successfully.")
        |> redirect(to: ride_path(conn, :show, ride))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", ride: ride, changeset: changeset)
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: current_user}} = conn, %{"id" => id}) do
    ride = Events.get_ride!(id)
    {:ok, _ride} = Events.delete_ride(ride)

    conn
    |> put_flash(:info, "Ride deleted successfully.")
    |> redirect(to: ride_path(conn, :index))
  end
end
