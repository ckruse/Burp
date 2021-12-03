import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :burp, BurpWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :burp, Burp.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "burp_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :burp, Burp.Mailer, adapter: Swoosh.Adapters.Test
config :burp, :scheme, "http"
