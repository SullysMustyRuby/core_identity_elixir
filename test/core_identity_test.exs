defmodule CoreIdentityElixir.CoreIdentityTest do
  use ExUnit.Case

  alias CoreIdentityElixir.CoreIdentity
  alias CoreIdentityElixir.CoreIdentity.Mock

  describe "authenticate/1" do
    test "returns the decoded body when successful" do
      params = %{email: "erin@core_apis.co.jp", password: "password"}
      assert {:ok, tokens} = CoreIdentity.authenticate(params)
      assert tokens["access_token"] != nil
      assert tokens["refresh_token"] != nil
    end

    test "returns error when authentication fails" do
      params = %{email: "nope@archer.com", password: "password"}
      assert {:error, "Returned status: 400 with message: bad request"} == CoreIdentity.authenticate(params)
    end
  end

  describe "get_certs/0" do
    test "returns current public key certs" do
      certs = CoreIdentity.get_certs()
      assert 2 == length(certs)
    end
  end

  describe "get_certs/1" do
    test "returns the public key cert with the kid" do
      cert = CoreIdentity.get_certs("Z6s25OvX-NulYhm1iKwRX6jkU2AdpOIvNZvYy3WW-oE")
      assert cert["kid"] == "Z6s25OvX-NulYhm1iKwRX6jkU2AdpOIvNZvYy3WW-oE"
    end

    test "returns nil if no cert matches the kid" do
      assert nil == CoreIdentity.get_certs("RX6jkU2AdpOIvNZvYy3WW-oEZ6s25OvX-NulYhm1iKw")
    end
  end

  describe "get_providers/0" do
    test "returns current list of providers" do
      assert {:ok, providers} = CoreIdentity.get_providers()
      assert 2 == length(providers)
    end
  end

  describe "parse_token/1" do
    test "returns user params from claims when token is valid" do
      tokens = Mock.tokens()

      assert {:ok, user_params} =
               CoreIdentity.parse_token(%{"access_token" => tokens[:access_token]})

      assert user_params[:uid] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert user_params[:user_type] == "Identities.User"

      assert {:ok, user_params} = CoreIdentity.parse_token(tokens)
      assert user_params[:uid] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert user_params[:user_type] == "Identities.User"
    end

    test "returns error when fails" do
      token =
        "eyJraWQiOiJvNFhRbVNLTHlLN1I0ejhDUWRLaVNDQVQ4ZmhnWFlNVWRLUUlUU0Rra2xJIiwiYWxnIjoiUlMyNTYiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL3N0YWdlLWlkZW50aXR5Lmh1YnN5bmNoLmNvbSIsImVtYWlsIjoibm90X2VyaW5AaGl2ZWxvY2l0eS5jby5qcCIsImV4cCI6MTYxNDY1NTQzNSwiaWF0IjoxNjE0NjUxODM1LCJpc3MiOiJIdWJJZGVudGl0eSIsImp0aSI6Ijk0NWZiODk0LTJjYTYtNGQ4Ni1hMTYzLThkZTdhOTNkMTYzYSIsIm5iZiI6MTYxNDY1MTgzNCwib3duZXJfdHlwZSI6bnVsbCwib3duZXJfdWlkIjpudWxsLCJzdWIiOiJJZGVudGl0aWVzLlVzZXI6MzgwNTQ5ZDEtY2Y5YS00YmNiLWI2NzEtYTI2NjdlOGQyMzAxIiwidHlwIjoiYWNjZXNzIiwidWlkIjoiMzgwNTQ5ZDEtY2Y5YS00YmNiLWI2NzEtYTI2NjdlOGQyMzAxIn0.nesXK09oqUIYZWNdphzcA4IbXGaOlMUd_dH_NjprRspBrlNhq4P78ou62bVcBu5vmL3kSqEwXsGDnjJTSApPRn8XvojmC72QG8_Ld2uv3n13alQmTFckq50sLRzqrzJad_oYTpZsjVi2yoHK35H_2BLwKQk5GpkKV6UIB8y7KntsLOZvS1RC5bwIP1paqTP-_bT3N1UnDeWDZkUL-vlfNTinMutOqz_GQGR1wVim4hJ7mEauDgyZxUJR5GiLdTXGLo4-0I1MDfuI3j4CLCvgt1YFgKikfiONZFzFL6vlJY0MwAU6ytGvJKJ1EZqozs4rbhBnLMpe6wCIglvITAXlSw"

      assert {:error, :signature_fail} == CoreIdentity.parse_token(%{"access_token" => token})
    end
  end
end
