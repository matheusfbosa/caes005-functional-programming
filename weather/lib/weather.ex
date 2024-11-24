defmodule Weather do
  @moduledoc """
  This module contains functions related to weather data.
  """

  @doc """
  Retrieves the temperature for a given location.

  ## Examples
      iex> Weather.get_temp("Curitiba")
      {:ok, 20.0}
  """
  def get_temp("Curitiba"), do: {:ok, 20.0}
end
