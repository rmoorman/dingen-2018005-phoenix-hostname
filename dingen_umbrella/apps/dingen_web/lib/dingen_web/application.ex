defmodule DingenWeb.Application do
  use Application

  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the cache first as we need it for the host
      # validation within the # endpoint's plugs
      DingenWeb.DynamicHost.Storage.Cache,

      # Start the endpoint when the application starts
      {DingenWeb.Endpoint, []},

      # Start your own worker by calling: DingenWeb.Worker.start_link(arg1, arg2, arg3)
      # {DingenWeb.Worker, [arg1, arg2, arg3]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DingenWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DingenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
