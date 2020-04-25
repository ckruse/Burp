defmodule Burp.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      Burp.Repo,
      Burp.Release,
      # Start the PubSub system
      {Phoenix.PubSub, name: Burp.PubSub},
      # Start the endpoint when the application starts
      BurpWeb.Endpoint
      # Start your own worker by calling: Burp.Worker.start_link(arg1, arg2, arg3)
      # worker(Burp.Worker, [arg1, arg2, arg3]),
    ]

    :telemetry.attach(
      "appsignal-ecto",
      [:burp, :repo, :query],
      &Appsignal.Ecto.handle_event/4,
      nil
    )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Burp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BurpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
