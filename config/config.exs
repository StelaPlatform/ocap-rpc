import Config

# log related
config :logger,
  level: :info,
  utc_log: false

config :logger, :console,
  format: "$date $time [$level] $message\n",
  colors: [info: :green]

config :ocap_rpc, :eth,
  conn: %{
    hostname: "localhost",
    port: 8545
  },
  timeout: 5_000,
  chain_id: 1

config :ocap_rpc, :btc,
  conn: %{
    hostname: "localhost",
    port: 8332
  },
  timeout: 5_000

config :ocap_rpc, :ipfs,
  conn: %{
    hostname: "localhost",
    port: 5001
  },
  timeout: 5_000

config :ocap_rpc,
  env: config_env()

import_config "#{config_env()}.exs"
