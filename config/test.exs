use Mix.Config

config :core_identity_elixir, CoreIdentityElixir.TestEndpoint,
  url: [host: "localhost"],
  http: [port: 4002],
  render_errors: [
    view: CoreIdentityElixir.Phoenix.ErrorView,
    accepts: ~w(html json),
    layout: false
  ],
  pubsub_server: CoreIdentityElixir.PubSub,
  secret_key_base: "nHe507xECwnY7JAjLDIL8jFcgrgUFKCP7xV+bKsf2YETkRylVMMCgBzagg+SRB3Y",
  server: false

config :phoenix, :json_library, Jason

config :core_identity_elixir, :http_client, CoreIdentityElixir.CoreIdentity.Mock
config :core_identity_elixir, :core_identity_url, "localhost"
config :core_identity_elixir, :destroy_cookie, true
# Print only warnings and errors during test
config :logger, level: :warn
