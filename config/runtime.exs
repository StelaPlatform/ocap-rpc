import Config

config :ocap_rpc, :btc,
  conn: %{
    hostname: System.get_env("BTC_RPC_HOST", "localhost"),
    port: System.get_env("BTC_RPC_PORT", "8332"),
    user: System.get_env("BTC_PRC_USER", ""),
    password: System.get_env("BTC_RPC_PASSWORD", "")
  }

config :ocap_rpc, :eth,
  conn: %{
    hostname: System.get_env("ETH_RPC_HOST", "localhost"),
    port: System.get_env("ETH_RPC_PORT", "8545")
  },
  chain_id: System.get_env("ETH_CHAIN_ID", "1") |> String.to_integer()

config :ocap_rpc, :ipfs,
  conn: %{
    hostname: System.get_env("IPFS_RPC_HOST", "localhost"),
    port: System.get_env("IPFS_RPC_PORT", "5001")
  }
