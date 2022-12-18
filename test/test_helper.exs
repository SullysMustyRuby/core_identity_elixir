children = [
  {Phoenix.PubSub, name: CoreIdentityElixir.PubSub},
  CoreIdentityElixir.TestEndpoint
]

opts = [strategy: :one_for_one, name: CoreIdentityElixir.Supervisor]
Supervisor.start_link(children, opts)

ExUnit.start()
