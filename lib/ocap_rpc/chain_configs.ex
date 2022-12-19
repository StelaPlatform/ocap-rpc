defmodule OcapRpc.ChainConfigs do
  @btc_configs %{
    hostname: {"OCAP_RPC_BTC_HOST", "localhost"},
    port: {"OCAP_RPC_BTC_PORT", 8332},
    user: {"OCAP_PRC_BTC_USER", ""},
    password: {"OCAP_RPC_BTC_PASSWORD", ""},
    timeout: {"OCAP_RPC_TIMEOUT", 5_000}
  }

  @eth_configs %{
    hostname: {"OCAP_RPC_ETH_HOST", "localhost"},
    port: {"OCAP_RPC_ETH_PORT", 8545},
    chain_id: {"OCAP_RPC_ETH_CHAIN_ID", 1},
    timeout: {"OCAP_RPC_TIMEOUT", 5_000}
  }

  @ipfs_configs %{
    hostname: {"OCAP_RPC_IPFS_HOST", "localhost"},
    port: {"OCAP_RPC_IPFS_PORT", 5001},
    timeout: {"OCAP_RPC_TIMEOUT", 5_000}
  }

  def update_config(), do: Enum.each([:btc, :eth, :ipfs], &update_config/1)

  defp update_config(chain) do
    configs =
      case chain do
        :btc -> @btc_configs
        :eth -> @eth_configs
        :ipfs -> @ipfs_configs
      end
      |> Enum.map(fn {key, {sys_env, default}} ->
        get_actual_value(chain, key, {sys_env, default})
      end)
      |> Enum.into(%{}, fn {k, v} -> {k, v} end)

    Application.put_env(:ocap_rpc, chain, configs)
  end

  defp get_actual_value(chain, key, {sys_env, default}) do
    override =
      :ocap_rpc
      |> Application.get_env(chain, [])
      |> Keyword.get(key, default)

    value =
      sys_env
      |> System.get_env()
      |> Kernel.||(override)
      |> cast(default)

    {key, value}
  end

  defp cast(value, default) when is_integer(default), do: to_integer(value)
  defp cast(value, default) when is_number(default), do: to_float(value)
  defp cast(value, default) when is_atom(default), do: to_atom(value)
  defp cast(value, _), do: value

  defp to_integer(v) when is_integer(v), do: v
  defp to_integer(v), do: String.to_integer(v)

  defp to_float(v) when is_number(v), do: v
  defp to_float(v), do: String.to_float(v)

  defp to_atom(v) when is_atom(v), do: v
  defp to_atom(v), do: String.to_atom(v)
end
