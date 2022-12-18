defmodule CoreIdentityElixir.CoreIdentity.TokenTest do
  use ExUnit.Case

  alias CoreIdentityElixir.CoreIdentity.Token
  alias CoreIdentityElixir.CoreIdentity.Mock

  describe "parse/1" do
    test "returns user params from claims when token is valid" do
      tokens = Mock.tokens()
      assert {:ok, user_params} = Token.parse(tokens[:access_token])
      assert user_params[:uid] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert user_params[:user_type] == "Identities.User"
    end

    test "returns error when signature fails" do
      token =
        "eyJraWQiOiJvNFhRbVNLTHlLN1I0ejhDUWRLaVNDQVQ4ZmhnWFlNVWRLUUlUU0Rra2xJIiwiYWxnIjoiUlMyNTYiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL3N0YWdlLWlkZW50aXR5Lmh1YnN5bmNoLmNvbSIsImVtYWlsIjoibm90X2VyaW5AaGl2ZWxvY2l0eS5jby5qcCIsImV4cCI6MTYxNDY1NTQzNSwiaWF0IjoxNjE0NjUxODM1LCJpc3MiOiJIdWJJZGVudGl0eSIsImp0aSI6Ijk0NWZiODk0LTJjYTYtNGQ4Ni1hMTYzLThkZTdhOTNkMTYzYSIsIm5iZiI6MTYxNDY1MTgzNCwib3duZXJfdHlwZSI6bnVsbCwib3duZXJfdWlkIjpudWxsLCJzdWIiOiJJZGVudGl0aWVzLlVzZXI6MzgwNTQ5ZDEtY2Y5YS00YmNiLWI2NzEtYTI2NjdlOGQyMzAxIiwidHlwIjoiYWNjZXNzIiwidWlkIjoiMzgwNTQ5ZDEtY2Y5YS00YmNiLWI2NzEtYTI2NjdlOGQyMzAxIn0.nesXK09oqUIYZWNdphzcA4IbXGaOlMUd_dH_NjprRspBrlNhq4P78ou62bVcBu5vmL3kSqEwXsGDnjJTSApPRn8XvojmC72QG8_Ld2uv3n13alQmTFckq50sLRzqrzJad_oYTpZsjVi2yoHK35H_2BLwKQk5GpkKV6UIB8y7KntsLOZvS1RC5bwIP1paqTP-_bT3N1UnDeWDZkUL-vlfNTinMutOqz_GQGR1wVim4hJ7mEauDgyZxUJR5GiLdTXGLo4-0I1MDfuI3j4CLCvgt1YFgKikfiONZFzFL6vlJY0MwAU6ytGvJKJ1EZqozs4rbhBnLMpe6wCIglvITAXlSw"

      assert {:error, :signature_fail} == Token.parse(token)
    end

    test "returns error if decoding fails" do
      token =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.dGhpcyBpcyB3cm9uZw==.YkG-4ZXEzCZCGmRL0VPI-Bu1DY8_6shXfeNEnSAx0M77gpZHUZyO4E30JtLoiN_PdRdzBDf6JSaQRZr3xtaEmQ"

      assert {:error, :token_decode_fail} == Token.parse(token)
    end

    test "returns error if claims parse fails" do
      token =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodWJfaWRlbnRpdHkiLCJleHAiOjE2MDk4MjY0NjMsImlhdCI6MTYwOTc0MDA2MywiaXNzIjoiaHViX2lkZW50aXR5IiwianRpIjoiNjRhNjM1MDItYTE1Ni00MDhlLTk2MmYtOWZiODgxMmVmNzliIiwibmJmIjoxNjA5NzQwMDYyLCJ0eXAiOiJhY2Nlc3MifQ.YkG-4ZXEzCZCGmRL0VPI-Bu1DY8_6shXfeNEnSAx0M77gpZHUZyO4E30JtLoiN_PdRdzBDf6JSaQRZr3xtaEmQ"

      assert {:error, :claims_parse_fail} == Token.parse(token)
    end

    test "returns error if signature fails" do
      token =
        "eyJraWQiOiJOaHRjRDkyYnVCcTU5dE1nREFXNlNFU3VZcW9Lazl5MXc0NGs0NHdpM1pZIiwiYWxnIjoiUlMyNTYiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL2FwcC1nbGF5LmpwLyIsImVtYWlsIjoiZXJpbkBoaXZlbG9jaXR5LmNvLmpwIiwiZXhwIjoxNjE0NjU3NjYxLCJpYXQiOjE2MTQ2NTQwNjEsImlzcyI6Ikh1YklkZW50aXR5IiwianRpIjoiZDBkZGQyNGQtMDYwNi00MGJjLWFmNjktYjQzNDhkNzAyN2FkIiwibmJmIjoxNjE0NjU0MDYwLCJvd25lcl90eXBlIjoiTW9ydHkiLCJvd25lcl91aWQiOiJSb2JvY3VsdXNtZWVzZWVrcyIsInN1YiI6IklkZW50aXRpZXMuVXNlcjowN2EwODY3My1kOTlkLTRkZmItYTJjNy1lNjkyMzViZjAyM2YiLCJ0eXAiOiJhY2Nlc3MiLCJ1aWQiOiIwN2EwODY3My1kOTlkLTRkZmItYTJjNy1lNjkyMzViZjAyM2YifQ.zcPyYOV-LcOxQukz3Q14MrxLNnvK6bk7GKQBW1QgIfBpXNdYyWNxVOsPlOFl7zj1nWy19jJ6773QOZJ2FWTj_WxzVU0Fc5BOanUfNnWqQN9OvcSfdOvb10BStf0nCULRiN4kwllcy5tSrwCQxKaRmTh4p7G_R6zIa7qvWUAhnbwGNxhQLQePYnU9_Uh1SpV6tY-9zdcZ46grA7BhKTtCKhLXfo5jJdzVOJxQTtih7r9UvOzP49ytI6pQjumhHrvTp8gvUWwKPdkIu5sIF-aBtbpdfm9xQXwBPyJr1uO1izyFADkyhNq7-g_9jDnSLFmCFo0nHZYcYUsjnePbUVsRug"

      assert {:error, :signature_parse_fail} == Token.parse(token)
    end
  end
end
