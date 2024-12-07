defmodule WeatherTest do
  use ExUnit.Case, async: true
  import Mox

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
end
