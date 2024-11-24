defmodule WeatherTest do
  use ExUnit.Case
  doctest Weather

  test "fetches the temperature for a city" do
    assert Weather.get_temp("Curitiba") == {:ok, 20.0}
  end
end
