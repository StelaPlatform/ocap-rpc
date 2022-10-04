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

## Configuration

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

If you just want to use one of these chain, you can do something like:

```elixir
config :ocap_rpc, :eth, chain_id: 31337
```

## Environment Variable Dependencies

Following environment variables are used to control ocap-rpc at run time.

- `BTC_RPC_HOST`: `localhost` by default
- `BTC_RPC_PORT`: `8332` by default
- `BTC_PRC_USER`: empty by default
- `BTC_RPC_PASSWORD`: empty by default
- `ETH_RPC_HOST`: `localhost` by default
- `ETH_RPC_PORT`: `8545` by default
- `IPFS_RPC_HOST`: `localhost` by default
- `IPFS_RPC_PORT`: `5001` by dy default

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
