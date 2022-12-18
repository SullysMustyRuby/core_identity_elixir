defmodule CoreIdentityElixir.TestController do
  use Phoenix.Controller, namespace: CoreIdentityElixir

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def other(conn, _params) do
    render(conn, "index.html")
  end
end
