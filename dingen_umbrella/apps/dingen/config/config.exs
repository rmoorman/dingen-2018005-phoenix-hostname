use Mix.Config

config :dingen, :initial_allowed_hosts, ["localhost"]

import_config "#{Mix.env}.exs"
