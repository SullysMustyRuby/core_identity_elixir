use Mix.Config

config :core_identity_elixir, :core_identity_url, "https://identity.core-apis.com"
config :core_identity_elixir, :core_identity_api_version, "/api/v1"
config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
