defmodule CoreIdentityElixir.Phoenix.AuthenticationTest do
  use CoreIdentityElixir.ConnCase

  alias CoreIdentityElixir.Authentication

  describe "fetch_current_user/2" do
    setup do
      current_user = %{
        uid: "uid_1234",
        user_type: "CoreIdentity.User"
      }

      conn = init_test_session(build_conn(), %{current_user: current_user})
      %{current_user: current_user, conn: conn}
    end

    test "puts current_user into assigns", %{current_user: current_user, conn: conn} do
      current_user_conn = Authentication.fetch_current_user(conn, %{})
      assert current_user_conn.assigns[:current_user] == current_user
    end
  end

  describe "login_user/2" do
    setup do
      current_user = %{
        uid: "uid_1234",
        user_type: "CoreIdentity.User"
      }

      conn = init_test_session(build_conn(), %{})
      %{current_user: current_user, conn: conn}
    end

    test "puts the user in the session", %{current_user: current_user, conn: conn} do
      logged_in = Authentication.login_user(conn, current_user)
      assert get_session(logged_in, :current_user) == current_user
    end

    test "assigns the user to the session", %{current_user: current_user, conn: conn} do
      logged_in = Authentication.login_user(conn, current_user)
      assert logged_in.assigns[:current_user] == current_user
    end

    test "assigns user_return_to if in session", %{current_user: current_user} do
      conn = init_test_session(build_conn(), %{user_return_to: "/other/path"})

      return_conn = Authentication.login_user(conn, current_user)
      assert redirected_to(return_conn) =~ "/other/path"
    end
  end

  describe "logout_user/1" do
    setup do
      current_user = %{
        uid: "uid_1234",
        user_type: "CoreIdentity.User"
      }

      conn =
        build_conn()
        |> put_req_cookie("_core_identity_access", "test_cookie_id")
        |> init_test_session(%{current_user: current_user})
        |> Authentication.fetch_current_user(%{})

      %{current_user: current_user, conn: conn}
    end

    test "clears the session", %{current_user: current_user, conn: conn} do
      assert conn.assigns[:current_user] == current_user
      assert get_session(conn, :current_user) == current_user

      logged_out = Authentication.logout_user(conn)

      assert logged_out.assigns[:current_user] == nil
      assert get_session(logged_out, :current_user) == nil
    end

    test "redirects to root path", %{conn: conn} do
      logged_out = Authentication.logout_user(conn)
      assert redirected_to(logged_out) =~ "/"
    end
  end

  describe "require_authenticated_user/2" do
    setup do
      current_user = %{
        uid: "uid_1234",
        user_type: "CoreIdentity.User"
      }

      conn =
        build_conn()
        |> init_test_session(%{})
        |> fetch_flash()

      %{current_user: current_user, conn: conn}
    end

    test "redirects to sessions new path for unauthenticated users", %{conn: conn} do
      redirected_conn = Authentication.require_authenticated_user(conn, %{})
      assert redirected_to(redirected_conn) =~ "/sessions/new"
      assert redirected_conn.halted
      assert get_flash(redirected_conn, :error) =~ "You must log in to access this page."
    end

    test "allows an authenticated user access", %{current_user: current_user, conn: conn} do
      auth_conn = Plug.Conn.assign(conn, :current_user, current_user)
      response = Authentication.require_authenticated_user(auth_conn, %{})
      refute response.halted
      assert get_flash(response, :error) == nil
    end
  end
end
