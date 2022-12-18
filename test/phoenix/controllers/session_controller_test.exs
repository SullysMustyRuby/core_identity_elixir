defmodule CoreIdentityElixir.Phoenix.Controllers.SessionControllerTest do
  use CoreIdentityElixir.ConnCase
  alias CoreIdentityElixir.CoreIdentity.Mock

  describe "new/2" do
    test "redirects to CoreIdentity", %{conn: conn} do
      new_conn = get(conn, Routes.session_path(conn, :new))
      assert redirected_to(new_conn) =~ "localhost/browser/v1/providers?api_key="
    end
  end

  describe "create/2" do
    test "with valid core_identity cookie assigns current_user", %{conn: conn} do
      response =
        conn
        |> get(Routes.session_path(conn, :create, %{user_token: "test_cookie_id"}))

      assert redirected_to(response) == "/"
      current_user = get_session(response, :current_user)

      assert current_user["email"] == "faranggorira@gmail.com"
      assert current_user["owner"] == "CoreIdentity.Identities.User"
      assert current_user["response"] == "CurrentUser"
      assert current_user["uuid"] == "user_e4dfcb4f-698d-4be4-8377-927e50b7d352"
    end
  end

  describe "delete/2" do
    test "without core_identity destroy true, logs a user out and returns to root path when set in config",
         %{conn: conn} do
      response =
        conn
        |> init_test_session(%{current_user: Mock.current_user()})
        |> put_req_cookie("_core_identity_access", "test_cookie_id")
        |> delete(Routes.session_path(conn, :destroy))

      assert redirected_to(response) == "/"
      assert get_session(response, :current_user) == nil
    end
  end
end
