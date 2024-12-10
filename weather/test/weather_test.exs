defmodule WeatherTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import Mox
  import StreamData

  setup :verify_on_exit!

  @base_url "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"
  @api_key "API_KEY"

  describe "get_temp/1" do
    test "fetches the temperature for a city" do
      response_body =
        Jason.encode!(%{
          "currentConditions" => %{"temp" => 20.0}
        })

      expect(HTTPoison.BaseMock, :get, fn url, _headers, _options ->
        assert url ==
                 "#{@base_url}/Curitiba?unitGroup=metric&include=current&key=#{@api_key}&contentType=json"

        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}}
      end)

      assert Weather.get_temp("Curitiba") == {:ok, 20.0}
    end

    test "invalid location" do
      error_response_body =
        Jason.encode!(%{
          "error" => "Invalid location"
        })

      expect(HTTPoison.BaseMock, :get, fn url, _headers, _options ->
        assert url ==
                 "#{@base_url}/invalidLocation?unitGroup=metric&include=current&key=#{@api_key}&contentType=json"

        {:ok, %HTTPoison.Response{status_code: 400, body: error_response_body}}
      end)

      assert Weather.get_temp("invalidLocation") ==
               {:error, "Request failed with status code: 400"}
    end
  end

  describe "celsius_to_fahrenheit/1" do
    test "converts Celsius to Fahrenheit correctly" do
      assert Weather.celsius_to_fahrenheit(0.0) == 32.0
      assert Weather.celsius_to_fahrenheit(100.0) == 212.0
      assert Weather.celsius_to_fahrenheit(-40.0) == -40.0
    end

    property "converts random Celsius values to Fahrenheit" do
      check all(celsius <- float(min: -100.0, max: 100.0)) do
        fahrenheit = Weather.celsius_to_fahrenheit(celsius)
        assert fahrenheit == celsius * 9 / 5 + 32
      end
    end
  end
end
