import Config

# log related
config :logger,
  level: :debug,
  utc_log: false

config :logger, :console,
  format: "$date $time [$level] $message\n",
  colors: [info: :green]

config :ocap_rpc,
  env: config_env()

import_config "#{config_env()}.exs"
