import Config

alias OcapRpc.Internal.Utils

config :ocap_rpc, :btc,
  conn: %{
    hostname: Utils.get_actual_env("OCAP_RPC_BTC_HOST", :btc, [:conn, :hostname]),
    port: Utils.get_actual_env("OCAP_RPC_BTC_PORT", :btc, [:conn, :port]),
    user: Utils.get_actual_env("OCAP_PRC_BTC_USER", :btc, [:conn, :user]),
    password: Utils.get_actual_env("OCAP_RPC_BTC_PASSWORD", :btc, [:conn, :password])
  }

config :ocap_rpc, :eth,
  conn: %{
    hostname: Utils.get_actual_env("OCAP_RPC_ETH_HOST", :eth, [:conn, :hostname]),
    port: Utils.get_actual_env("OCAP_RPC_ETH_PORT", :eth, [:conn, :port])
  },
  chain_id:
    Utils.get_actual_env("OCAP_RPC_ETH_CHAIN_ID", :eth, [:chain_id]) |> String.to_integer()

config :ocap_rpc, :ipfs,
  conn: %{
    hostname: Utils.get_actual_env("OCAP_RPC_IPFS_HOST", :ipfs, [:conn, :hostname]),
    port: Utils.get_actual_env("OCAP_RPC_IPFS_PORT", :ipfs, [:conn, :port])
  }
