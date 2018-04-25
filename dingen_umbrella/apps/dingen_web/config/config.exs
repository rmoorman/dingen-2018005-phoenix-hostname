# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :dingen_web,
  namespace: DingenWeb

# Configures the endpoint
config :dingen_web, DingenWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wSvYH+FXSiKTxjQFHA4lQQvH7LSud0A0/+opqlbWIE9w7aKUIRbhzJhLgog3YJS9",
  render_errors: [view: DingenWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DingenWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :dingen_web, :generators,
  context_app: :dingen

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
