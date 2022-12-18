defmodule CoreIdentityElixir.MockServer do
  def request(:get, "localhost/api/v1/oauth/certs", "", _headers, _params) do
    {:ok, %HTTPoison.Response{status_code: 200, body: Jason.encode!(certs())}}
  end

  def request(:get, "localhost/api/v1/providers", "", _headers, _params) do
    {:ok, %HTTPoison.Response{status_code: 200, body: Jason.encode!(providers())}}
  end

  def request(:get, "localhost/api/v1/current_user/test_cookie_id", "", _headers, _params) do
    {:ok, %HTTPoison.Response{status_code: 200, body: Jason.encode!(current_user())}}
  end

  def request(:get, "localhost/api/v1/users/user_uid/emails", "", _headers, _params) do
    {:ok, %HTTPoison.Response{status_code: 200, body: Jason.encode!(emails())}}
  end

  def post("localhost/api/v1/providers/core_identity", body, _headers) do
    case Jason.decode!(body) do
      %{"email" => "erin@core_apis.co.jp"} -> token_response()
      _ -> fail_response()
    end
  end

  def post("localhost/api/v1/users/core_identity/emails", body, _headers) do
    case Jason.decode!(body) do
      %{"email" => %{"address" => address}} -> email_response(address)
      _ -> fail_response()
    end
  end

  def post("localhost/api/v1/users/core_identity/verification", body, _headers) do
    case Jason.decode!(body) do
      %{"reference" => "reference"} -> verification_response()
      _ -> fail_response()
    end
  end

  def post("localhost/api/v1/users/core_identity/verification/renew", body, _headers) do
    case Jason.decode!(body) do
      %{"old_reference" => "old_reference", "new_reference" => "new_reference"} ->
        verification_response()

      _ ->
        fail_response()
    end
  end

  def put("localhost/api/v1/providers/core_identity", body, _headers) do
    case Jason.decode!(body) do
      %{"email" => "erin@core_apis.co.jp"} -> token_response()
      _ -> fail_response()
    end
  end

  def put("localhost/api/v1/users/core_identity/verification/validate", body, _headers) do
    case Jason.decode!(body) do
      %{"reference" => "reference", "code" => code} when is_integer(code) ->
        validation_response(code)

      _ ->
        fail_response()
    end
  end

  def delete(_url, _headers),
    do: {:ok, %HTTPoison.Response{status_code: 202, body: "successful operation"}}

  def current_user do
    %{
      "Object" => "CurrentUser",
      "uid" => "380549d1-cf9a-4bcb-b671-a2667e8d2301",
      "user_type" => "Identities.User"
    }
  end

  def emails do
    [
      %{
        "Object" => "Email",
        "address" => "test@core_apis.co.jp",
        "confirmed_at" => "2021-04-07T02:52:31Z",
        "primary" => true,
        "uid" => "81b7d2ef-43ef-42f8-922d-62602eac518a"
      },
      %{
        "Object" => "Email",
        "address" => "test2@core_apis.co.jp",
        "confirmed_at" => "2021-06-03T07:59:55Z",
        "primary" => false,
        "uid" => "8c8c09a7-b500-430c-a45c-569bd9fa5a08"
      }
    ]
  end

  # This is a valid set of tokens to test with. The signature will validate with the certs below
  # The user will be:
  # %{
  #   owner_type: nil,
  #   owner_uid: nil,
  #   uid: "380549d1-cf9a-4bcb-b671-a2667e8d2301",
  #   user_type: "Identities.User"
  # }
  def tokens do
    %{
      access_token:
        "eyJraWQiOiJvNFhRbVNLTHlLN1I0ejhDUWRLaVNDQVQ4ZmhnWFlNVWRLUUlUU0Rra2xJIiwiYWxnIjoiUlMyNTYiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL3N0YWdlLWlkZW50aXR5Lmh1YnN5bmNoLmNvbSIsImVtYWlsIjoiZXJpbkBoaXZlbG9jaXR5LmNvLmpwIiwiZXhwIjoxNjE0NjU1NDM1LCJpYXQiOjE2MTQ2NTE4MzUsImlzcyI6Ikh1YklkZW50aXR5IiwianRpIjoiOTQ1ZmI4OTQtMmNhNi00ZDg2LWExNjMtOGRlN2E5M2QxNjNhIiwibmJmIjoxNjE0NjUxODM0LCJvd25lcl90eXBlIjpudWxsLCJvd25lcl91aWQiOm51bGwsInN1YiI6IklkZW50aXRpZXMuVXNlcjozODA1NDlkMS1jZjlhLTRiY2ItYjY3MS1hMjY2N2U4ZDIzMDEiLCJ0eXAiOiJhY2Nlc3MiLCJ1aWQiOiIzODA1NDlkMS1jZjlhLTRiY2ItYjY3MS1hMjY2N2U4ZDIzMDEifQ.nesXK09oqUIYZWNdphzcA4IbXGaOlMUd_dH_NjprRspBrlNhq4P78ou62bVcBu5vmL3kSqEwXsGDnjJTSApPRn8XvojmC72QG8_Ld2uv3n13alQmTFckq50sLRzqrzJad_oYTpZsjVi2yoHK35H_2BLwKQk5GpkKV6UIB8y7KntsLOZvS1RC5bwIP1paqTP-_bT3N1UnDeWDZkUL-vlfNTinMutOqz_GQGR1wVim4hJ7mEauDgyZxUJR5GiLdTXGLo4-0I1MDfuI3j4CLCvgt1YFgKikfiONZFzFL6vlJY0MwAU6ytGvJKJ1EZqozs4rbhBnLMpe6wCIglvITAXlSw",
      refresh_token:
        "eyJraWQiOiJvNFhRbVNLTHlLN1I0ejhDUWRLaVNDQVQ4ZmhnWFlNVWRLUUlUU0Rra2xJIiwiYWxnIjoiUlMyNTYiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL3N0YWdlLWlkZW50aXR5Lmh1YnN5bmNoLmNvbSIsImV4cCI6MTYxNDY5NTAzNSwiaWF0IjoxNjE0NjUxODM1LCJpc3MiOiJIdWJJZGVudGl0eSIsImp0aSI6ImU0ZWQ2ZGZjLTA1YjQtNGVlNS1iYmVlLTY1NjA3YmM4N2EwNCIsIm5iZiI6MTYxNDY1MTgzNCwic3ViIjoiSWRlbnRpdGllcy5Vc2VyOjM4MDU0OWQxLWNmOWEtNGJjYi1iNjcxLWEyNjY3ZThkMjMwMSIsInR5cCI6InJlZnJlc2gifQ.bboodWqsiq8ErLcT0puF0ZYfyyjrtY_NY7LMilTNaAigzMud-KxQN-P6W6pZYm2qYTtb5JtabrA0KAEY5Q81XWMQta2Ard52uc9Eezw9JHZ03Mbiqw3vSPz71L4z7YBxEhGWmmrPd7ReeKcc3ImdX-lk2KouaVEiB3Ur17YweO0Eq8vx4-8rSEqKvwn7ibuGA8FotY7CWsvPZlUMsm7B__jyRdeuQ6qy1cfNauSM-SbjvVIRs3WCn0DMkCdAenO8S6HKvueDSAW8-wEwHqcum7Soex409D9Cjh0JUgf7eGfz2xXsPyFt22h0eDAMZT9fZsxjki1a_3FRvaUDzVpIig"
    }
  end

  defp email(address) do
    %{
      "Object" => "Email",
      "address" => address,
      "confirmed_at" => "2021-04-07T02:52:31Z",
      "primary" => false,
      "uid" => "81b7d2ef-43ef-42f8-922d-62602eac518a"
    }
  end

  def certs do
    [
      %{
        alg: "RS256",
        e: "AQAB",
        expires: 1_614_709_881,
        kid: "o4XQmSKLyK7R4z8CQdKiSCAT8fhgXYMUdKQITSDkklI",
        kty: "RSA",
        n:
          "195X2Odvn0D3ASJM2_6GmtnhrcFN4ajI1DNzOUAmqBMzSf_AdUC2yuvPKkZnoefd65gchPbQPnq0aQSRO2hOPWvhkspK6iJRS7uDRghhmGioo0lZCeerkSgR5CMAJX3oDYQmUSX_8ytjG-P3XBivVT0GvBPMCJpK0SgjGTkOsZEjdHMhJBhZBvrs7ZeXxsoVK_SEkcBhgM5m0tZi47Fb96TCRkxSgcPb4OOd75XILBwmIaHYO8LN_XSrZ7NxSacOm1n0YtPl7QLPDyn75QGRz_lBL6qGIgAMA5LNOKDc7m0Ib9q4W6cZA6EvjvpXRgaf2Eh-6eKWiVw9n0x7bbENnQ",
        use: "sig"
      },
      %{
        alg: "RS256",
        e: "AQAB",
        expires: 1_614_708_460,
        kid: "Z6s25OvX-NulYhm1iKwRX6jkU2AdpOIvNZvYy3WW-oE",
        kty: "RSA",
        n:
          "14HP9Fwk37wijRQIVzkBTIsZUZ0LrgVY72hOZzrgfYg3pvrSBUQx5htsLYOESgMZNHtmhRmoTMOG0y4K5JhzfF6lebwVHJb39ieFmQnwqvlCA37-eBB0Qpxbp_CF_z5s0y7aCkiCBIUstArHaCSa0d05phMlM0h7hZu6PwnWY-0XdQc4LHn680qTm_yR4MrCKlDdJDUUsuFJio-bCKiNpfhjruUixKh0xUYh1gtHiBXew4al5E8Zr68HlI09-KCnOgjE8V2zpMHcn3pLrs58m2H_MsuyqmAIzFlnmM0qOPtjnmQ4fIoYqJt-A7ZKajCB6C7xeaIZtm05nmK1gziCdw",
        use: "sig"
      }
    ]
  end

  def providers do
    [
      %{
        logo_url: "https://stage-identity.hubsynch.com/images/facebook.png",
        name: "facebook",
        request_url:
          "https://www.facebook.com/v9.0/dialog/oauth?client_id=2494840020818063&response_type=code&redirect_uri=https://stage-identity.hubsynch.com/api/v1/providers/oauth/response/facebook&scope=email&state=31E9B69E423EB0EBDE24FF8E0356973FC19821985E3D8DAD"
      },
      %{
        logo_url: "https://stage-identity.hubsynch.com/images/google.png",
        name: "google",
        request_url:
          "https://accounts.google.com/o/oauth2/v2/auth?client_id=221324018211-ustgqn7upord8ru5pbtnmj8u03dgd994.apps.googleusercontent.com&response_type=code&redirect_uri=https://stage-identity.hubsynch.com/api/v1/providers/oauth/response/google&scope=https://www.googleapis.com/auth/userinfo.email&state=31E9B69E423EB0EBDE24FF8E0356973FC19821985E3D8DAD"
      }
    ]
  end

  defp token_response do
    {:ok, %HTTPoison.Response{status_code: 200, body: Jason.encode!(tokens())}}
  end

  defp email_response(address) do
    {:ok, %HTTPoison.Response{status_code: 200, body: Jason.encode!(email(address))}}
  end

  defp verification_response() do
    {:ok, %HTTPoison.Response{status_code: 202, body: "successful operation"}}
  end

  defp validation_response(code) do
    case code do
      1122 ->
        {:ok, %HTTPoison.Response{status_code: 202, body: "verification success"}}

      _ ->
        {:ok, %HTTPoison.Response{status_code: 400, body: "{\"error\":\"verification failed\"}"}}
    end
  end

  defp fail_response do
    {:ok, %HTTPoison.Response{status_code: 400, body: "bad request"}}
  end
end
