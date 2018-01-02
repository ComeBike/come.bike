use Mix.Config

config :come_bike, ComeBikeWeb.Endpoint,
  secret_key_base: "${SECRET_KEY_BASE}",
  load_from_system_env: true,
  url: [host: "${PHX_HOST}", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

# Do not print debug messages in production
config :logger, level: :info

config :come_bike, ComeBikeWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "${DB_USER}",
  password: "${DB_PASS}",
  database: "${DB}",
  pool_size: 15
