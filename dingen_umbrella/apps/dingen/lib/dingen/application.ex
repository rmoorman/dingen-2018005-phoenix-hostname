defmodule Dingen.Application do
  @moduledoc """
  The Dingen Application Service.

  The dingen system business domain lives in this application.

  Exposes API to clients such as the `DingenWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    allowed_origins = Application.get_env(:dingen, :initial_allowed_origins)

    children = [
      {Dingen.AllowedOrigins, allowed_origins},
    ]

    supervisor_opts = [strategy: :one_for_one, name: Dingen.Supervisor]
    Supervisor.start_link(children, supervisor_opts)
  end
end
