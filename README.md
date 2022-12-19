# Block Chain RPC

Provide basic RPC functionalities for various Chain, in elixir way.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ocap_rpc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ocap_rpc, "~> 0.0.0"}
  ]
end
```

## Configurations

### Required config for build time

You need to set following config in your `config.exs` to build OCAP_RPC

```elixir
config :ocap_rpc,
  env: config_env()
```

### Default Values

If you want to override default values for configurations, you can copy over following configs and edit to your like, other wise OCAP_RPC will use system env described in next section.

```elixir
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
```

### Environment Variable

Following environment variables are used to control ocap-rpc at run time.

- `OCAP_RPC_BTC_HOST`
- `OCAP_RPC_BTC_PORT`
- `OCAP_PRC_BTC_USER`
- `OCAP_RPC_BTC_PASSWORD`
- `OCAP_RPC_ETH_HOST`
- `OCAP_RPC_ETH_PORT`
- `OCAP_RPC_ETH_CHAIN_ID`
- `OCAP_RPC_IPFS_HOST`
- `OCAP_RPC_IPFS_PORT`

## Appendix

Ethereum Chain ID:
```
    ethereum_mainnet: 1,
    morden: 2,
    expanse_mainnet: 2,
    ropsten: 3,
    rinkeby: 4,
    ubiq_mainnet: 8,
    ubiq_testnet: 9,
    rootstock_mainnet: 30,
    rootstock_testnet: 31,
    kovan: 42,
    ethereum_classic_mainnet: 61,
    ethereum_classic_testnet: 62,
    ewasm_testnet: 66,
    geth_private_chains: 1337,
    görli: 6284,
    stureby: 314158
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_bitcoin](https://hexdocs.pm/ex_bitcoin).
