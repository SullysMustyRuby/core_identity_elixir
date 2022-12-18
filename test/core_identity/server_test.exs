defmodule CoreIdentityElixir.CoreIdentity.ServerTest do
  use ExUnit.Case

  alias CoreIdentityElixir.CoreIdentity.Server

  describe "authenticate/1" do
    test "returns the decoded body when successful" do
      params = %{email: "erin@core_apis.co.jp", password: "password"}
      assert {:ok, tokens} = Server.authenticate(params)
      assert tokens["access_token"] != nil
      assert tokens["refresh_token"] != nil
    end

    test "returns error when authentication fails" do
      params = %{email: "nope@archer.com", password: "password"}
      assert {:error, "bad request"} == Server.authenticate(params)
    end
  end

  describe "get_certs/0" do
    test "returns current public key certs" do
      certs = Server.get_certs()
      assert 2 == length(certs)
    end
  end

  describe "get_providers/0" do
    test "returns current list of providers" do
      assert {:ok, providers} = Server.get_providers()
      assert 2 == length(providers)
    end
  end
end
