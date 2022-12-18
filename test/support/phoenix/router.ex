defmodule CoreIdentityElixir.TestRouter do
  use Phoenix.Router
  use CoreIdentityElixir.Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  scope "/", CoreIdentityElixir.Phoenix do
    pipe_through(:browser)

    core_identity_routes()
  end

  scope "/" do
    pipe_through(:browser)

    get("/", CoreIdentityElixir.TestController, :index)
  end

  scope "/" do
    pipe_through([:browser, :require_authenticated_user])

    get("/other/path", CoreIdentityElixir.TestController, :other)
  end
end
