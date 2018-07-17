# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_api_101,
  ecto_repos: [PhoenixApi101.Repo]

# Configures the endpoint
config :phoenix_api_101, PhoenixApi101Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/y/JBKgoCCGz1MRSUectWo+39VhtaNE04bY3fGWEK1AVmg0009pCDKYsccdzI1sm",
  render_errors: [view: PhoenixApi101Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixApi101.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :phoenix, :format_encoders, "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"],
  "application/json" => ["json"]
}

config :phoenix_api_101, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: ApiTestWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: ApiTestWeb.Endpoint
    ]
  }

config :guardian, Guardian.DB,
  repo: AppEx.Repo,
  schema_name: "guardian_tokens",
  # default: 60 minutes
  sweep_interval: 60

config :app_ex, AppEx.Auth.Guardian,
  issuer: "app_ex",
  secret_key: "lDio1ZZZpdEqzPo3NTGA0my3DCZfDIdbwX0CBssG6PDQe6fo0guh3Jj4axjt85UJ"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
