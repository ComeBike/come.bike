use Mix.Config

config :come_bike, ComeBikeWeb.Endpoint,
  secret_key_base: "${SECRET_KEY_BASE}",
  load_from_system_env: true,
  url: [host: "come.bike", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

# Do not print debug messages in production
config :logger, level: :info

config :come_bike, ComeBike.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "${DB_USER}",
  password: "${DB_PASS}",
  database: "${DB}",
  types: ComeBike.PostgresTypes,
  pool_size: 15

config :sentry,
  dsn: "${SENTRY_DNS}",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod]
