defmodule Dingen.Application do
  @moduledoc """
  The Dingen Application Service.

  The dingen system business domain lives in this application.

  Exposes API to clients such as the `DingenWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: Dingen.Supervisor)
  end
end
