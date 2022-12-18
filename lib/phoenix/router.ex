defmodule CoreIdentityElixir.Phoenix.Router do
  @moduledoc false
  use Phoenix.Router

  defmacro __using__(_opts \\ []) do
    quote do
      import CoreIdentityElixir.Authentication,
        only: [
          fetch_current_user: 2,
          require_authenticated_user: 2
        ]

      import unquote(__MODULE__),
        only: [core_identity_routes: 0]
    end
  end

  defmacro core_identity_routes do
    quote do
      scope "/core_identity", alias: false, as: false do
        delete("/sessions/destroy", CoreIdentityElixir.Phoenix.SessionController, :destroy)
        get("/sessions/new", CoreIdentityElixir.Phoenix.SessionController, :new)
        get("/sessions/create", CoreIdentityElixir.Phoenix.SessionController, :create)
      end
    end
  end
end
