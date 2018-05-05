use Mix.Config

config :dingen, :initial_allowed_origins, [
  "http://localhost:4000",
  "http://dingen.localhost:4000",
]

import_config "#{Mix.env}.exs"
