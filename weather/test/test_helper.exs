ExUnit.start()

Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)
Application.put_env(:weather, :http_client, HTTPoison.BaseMock)
