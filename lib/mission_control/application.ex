defmodule MissionControl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MissionControlWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MissionControl.PubSub},
      # Start the Endpoint (http/https)
      MissionControlWeb.Endpoint
      # Start a worker by calling: MissionControl.Worker.start_link(arg)
      # {MissionControl.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MissionControl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MissionControlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
