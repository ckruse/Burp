defmodule BurpWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :burp

  socket("/socket", BurpWeb.UserSocket, websocket: true)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(
    Plug.Static,
    at: "/",
    from: :burp,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt humans.txt security.txt)
  )

  plug(
    Plug.Static,
    at: "/.well-known",
    from: :burp,
    gzip: false,
    only: ~w(security.txt)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(
    Plug.Session,
    store: :cookie,
    key: "_burp_key",
    signing_salt: "3qIeNHjY"
  )

  plug(BurpWeb.Router)
end
