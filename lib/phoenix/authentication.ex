defmodule CoreIdentityElixir.Authentication do
  @moduledoc """
  The Authentication plug for use with restricted routes.
  Would like to attribute much of this code to the phx_gen_auth package.
  https://github.com/aaronrenner/phx_gen_auth
  Thank you.

  """
  import Plug.Conn
  import Phoenix.Controller

  @doc """
  Helper method to store the current_user in conn.assigns for easy use
  in views etc.
  """
  def fetch_current_user(conn, _opts) do
    current_user = get_session(conn, :current_user)
    assign(conn, :current_user, current_user)
  end

  @doc """
  Helper method to log in a user. This will store a user into the assign, as
  well as session under :current_user.
  Will redirect to "/"
  """
  def login_user(conn, current_user) do
    user_return_to = get_session(conn, :user_return_to)

   conn
    |> renew_session()
    |> put_session(:current_user, current_user)
    |> fetch_flash()
    |> put_flash(:info, "Successfully logged in with CoreIdentity")
    |> assign(:current_user, current_user)
    |> redirect(to: user_return_to || authenticated_redirect())
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def logout_user(conn) do
    conn
    |> renew_session()
    |> fetch_flash()
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: logged_out_redirect())
    |> halt()
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:"current_user"] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: login_path())
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing.
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> assign(:current_user, nil)
  end

  defp authenticated_redirect,
    do: Application.get_env(:core_identity_elixir, :authenticated_redirect) || "/"

  defp login_path, do: Application.get_env(:core_identity_elixir, :login_path) || "/sessions/new"

  defp logged_out_redirect,
    do: Application.get_env(:core_identity_elixir, :logged_out_redirect) || "/"
end
