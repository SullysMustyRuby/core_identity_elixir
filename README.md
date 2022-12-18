# CoreIdentityElixir

An Elixir Package designed to make implementing CoreIdentity authentication easy and fast.
In order to use this package you need to have an account with [CoreIdentity](https://stage-identity.hubsynch.com/)

Currently this is only for Internal projects. 
If you have a commercial interest please contact the Package Manager Erin Boeger through linkedIn or Github.

## Installation

The package can be installed by adding `core_identity_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:core_identity_elixir, "~> 0.1.0"}
  ]
end
```
## Setup

Setup your configuration in `config.exs, dev.exs, prod.exs` etc:

```elixir
config :core_identity_elixir, :url, # Either staging, production, or localhost
config :core_identity_elixir, :public_key, # The public key from CoreIdentity
```
Optional config settings
```elixir
config :core_identity_elixir, :authenticated_redirect, # This will allow a redirect after authentication, default is: "/"
config :core_identity_elixir, :login_path, # This will allow a redirect after authentication, default is: "/sessions/new"
config :core_identity_elixir, :logged_out_redirect, # This will allow a redirect after authentication, default is: "/"
```

Inside your Router add `use CoreIdentityElixir.Phoenix.Router` and include
the `core_identity_routes()`

in `router.exs`:

```elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router
  use CoreIdentityElixir.Phoenix.Router # <- Add CoreIdentity Router

  # router stuff..

  scope "/", MyAppWeb do
    pipe_through :browser

    core_identity_routes()  # <- Add CoreIdentity routes
    get "/", PageController, :index
  end
```
This will add the following routes to your application:
- session_path  DELETE  /sessions/logout CoreIdentityElixir.Phoenix.SessionController :delete
- session_path  GET     /sessions/new    CoreIdentityElixir.Phoenix.SessionController :new
- session_path  GET     /sessions/create CoreIdentityElixir.Phoenix.SessionController :create

If you want a `@current_user` helper then add `plug :fetch_current_user` to your pipeline.

## Restricted routes

For authentication required (restricted) routes add the plug `require_authenticated_user`
for example:

```elixir
scope "/", MyAppWeb do
  pipe_through [:browser, :require_authenticated_user]

  get "/something/restricted", PageController, :something
  get "/something_else/restricted", PageController, :something_else
end
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm) at
[core_identity_elixir](https://hexdocs.pm/core_identity_elixir)
