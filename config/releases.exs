import Config

config :burp, BurpWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: System.fetch_env!("BURP_PORT")],
  url: [scheme: "https", port: 443],
  secret_key_base: System.fetch_env!("BURP_SECRET_KEY")

config :burp, :storage_path, System.fetch_env!("BURP_STORAGE_PATH")
config :burp, :scheme, System.fetch_env!("BURP_HTTP_SCHEME")
config :burp, :port, System.fetch_env!("BURP_HTTP_PORT") |> String.to_integer()

# Configure your database
config :burp, Burp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.fetch_env!("BURP_DB_USER"),
  password: System.fetch_env!("BURP_DB_PASSWORD"),
  database: System.fetch_env!("BURP_DB_NAME"),
  pool_size: 15

config :burp, Burp.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: System.fetch_env!("BURP_SMTP_HOST"),
  port: System.fetch_env!("BURP_SMTP_PORT") |> String.to_integer(),
  username: System.fetch_env!("BURP_SMTP_USER"),
  password: System.fetch_env!("BURP_SMTP_PASSWORD"),
  tls: :if_available,
  auth: :always,
  retries: 3

config :burp,
  deploy_secret: System.fetch_env!("BURP_DEPLOY_SECRET"),
  deploy_script: System.fetch_env!("BURP_DEPLOY_SCRIPT")

config :gh_webhook_plug, secret: System.fetch_env!("BURP_DEPLOY_SECRET")
