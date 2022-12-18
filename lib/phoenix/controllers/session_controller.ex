defmodule CoreIdentityElixir.Phoenix.SessionController do
  @moduledoc false
  use Phoenix.Controller, namespace: CoreIdentityElixir

  alias CoreIdentityElixir.{Authentication, CoreIdentity}

  def new(conn, _params) do
    redirect(
      conn,
      external: "#{CoreIdentity.core_identity_url()}/browser/v1/providers?api_key=#{public_key()}"
    )
  end

  def create(conn, %{"user_token" => user_token}) do
    with {:ok, current_user} <- CoreIdentity.get_current_user(user_token) do
      Authentication.login_user(conn, current_user)
    end
  end

  def create(conn, _params) do
    Authentication.logout_user(conn)
  end

  def destroy(conn, _params) do
    conn
    |> Authentication.logout_user()
  end

  defp public_key do
    Application.get_env(:core_identity_elixir, :public_key)
  end
end
