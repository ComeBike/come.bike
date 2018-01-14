defmodule ComeBike.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias ComeBike.Repo
  use Timex

  alias ComeBike.Events.{Ride, SearchRides, Zip}

  @doc """
  Returns the list of rides.

  ## Examples

      iex> list_rides()
      [%Ride{}, ...]

  """
  def list_rides do
    Repo.all(
      from(
        r in Ride,
        preload: [:user],
        order_by: [asc: r.start_time]
      )
    )
  end

  def todays_rides do
    start_at = Timex.now() |> Timex.beginning_of_day()
    end_at = Timex.now() |> Timex.end_of_day()

    Repo.all(
      from(
        r in Ride,
        preload: [:user],
        where: r.start_time >= ^start_at,
        where: r.start_time <= ^end_at,
        order_by: [asc: r.start_time]
      )
    )
  end

  @doc """
  Gets a single ride.

  Raises `Ecto.NoResultsError` if the Ride does not exist.

  ## Examples

      iex> get_ride!(123)
      %Ride{}

      iex> get_ride!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ride!(id), do: Repo.one!(from(r in Ride, where: r.id == ^id, preload: [:user]))

  def get_ride_by_user!(id, user), do: Repo.get_by!(Ride, id: id, user_id: user.id)

  @doc """
  Search for rides

  ### Examples

      iex> search_rides(%{field: value})
      {:ok, %Ecto.Changeset{}, [%Ride{}, ...] }

      iex> search_rides(%{field: bad_value})
      {:error, error_message}

  """
  def search_rides(attrs) do
    %SearchRides{}
    |> SearchRides.changeset(attrs)
    |> IO.inspect()
    |> case do
      %Ecto.Changeset{valid?: true} = cs ->
        attrs |> IO.inspect()
        rides = ComeBike.Search.find_by_zip_in_n_miles(attrs)

        {:ok, rides}

      %{errors: errors} = cs ->
        {:error, "funk"}
    end

    # Do the searched
  end

  @doc """
  Creates a ride.

  ## Examples

      iex> create_ride(%{field: value})
      {:ok, %Ride{}}

      iex> create_ride(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ride(attrs \\ %{}) do
    %Ride{}
    |> Ride.new_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ride.

  ## Examples

      iex> update_ride(ride, %{field: new_value})
      {:ok, %Ride{}}

      iex> update_ride(ride, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ride(%Ride{} = ride, attrs) do
    ride
    |> Ride.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Ride.

  ## Examples

      iex> delete_ride(ride)
      {:ok, %Ride{}}

      iex> delete_ride(ride)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ride(%Ride{} = ride) do
    Repo.delete(ride)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ride changes.

  ## Examples

      iex> change_ride(ride)
      %Ecto.Changeset{source: %Ride{}}

  """
  def change_ride(%Ride{} = ride) do
    Ride.changeset(ride, %{})
  end
end
