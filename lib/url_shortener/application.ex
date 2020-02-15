defmodule UrlShortener.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias UrlShortenerWeb.Instrumenter

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      UrlShortener.Repo,
      # Start the endpoint when the application starts
      UrlShortenerWeb.Endpoint
      # Starts a worker by calling: UrlShortener.Worker.start_link(arg)
      # {UrlShortener.Worker, arg},
    ]

    # Prometheus setup
    require Prometheus.Registry

    Instrumenter.Phoenix.setup()
    Instrumenter.Pipeline.setup()

    if :os.type() == {:unix, :linux} do
      Prometheus.Registry.register_collector(:prometheus_process_collector)
    end

    :ok =
      :telemetry.attach(
        "prometheus-ecto",
        [:url_shortener, :repo, :query],
        &Instrumenter.Repo.handle_event/4,
        %{}
      )

    Instrumenter.Repo.setup()

    Instrumenter.PlugExporter.setup()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UrlShortener.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UrlShortenerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
