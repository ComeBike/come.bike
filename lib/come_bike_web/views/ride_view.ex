defmodule ComeBikeWeb.RideView do
  use ComeBikeWeb, :view

  def encode_address(%{
        start_location_name: start_location_name,
        start_address: start_address,
        start_city: start_city,
        start_state: start_state,
        start_zip: start_zip
      }) do
    start_address <> "+" <> start_city <> "+" <> start_state <> "+" <> start_zip
  end
end
