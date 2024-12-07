defmodule Weather do
  @moduledoc """
  This module contains functions related to weather data.
  """

  @doc """
  Retrieves the temperature for a given location.

  ## Examples
      iex> Weather.get_temp("Curitiba")
      {:ok, 20.0}

  ## Parameters
      - `location`: A string representing the location (e.g. "Curitiba").
  """
  def get_temp(location) do
    base_url =
      "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"

    api_key = "API_KEY"

    url =
      "#{base_url}/#{location}?unitGroup=metric&include=current&key=#{api_key}&contentType=json"

    case http_client().get(url, [], recv_timeout: 5000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode()
        |> handle_response()

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Request failed with status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed: #{reason}"}
    end
  end

  defp http_client do
    Application.get_env(:weather, :http_client)
  end

  defp handle_response({:ok, %{"currentConditions" => %{"temp" => temp}}}) do
    {:ok, temp}
  end

  defp handle_response({:ok, _}) do
    {:error, "Unexpected response format"}
  end

  defp handle_response({:error, reason}), do: {:error, reason}
end
